package Test::Mockingbird::DeepMock;

use strict;
use warnings;

use Exporter 'import';
use Carp qw(croak);
use Test::Mockingbird ();
use Test::More ();

our @EXPORT_OK = qw(deep_mock);

sub deep_mock ($$) {
	my ($plan, $code) = @_;

	croak 'deep_mock expects a HASHREF plan' unless ref $plan eq 'HASH';

	my %handles;

	_install_mocks($plan->{mocks} || [], \%handles);

	my ($wantarray, @ret, $ret, $err);
	$wantarray = wantarray;

	if ($wantarray) {
		@ret = eval { $code->() };
		$err = $@;
	} elsif (defined $wantarray) {
		$ret = eval { $code->() };
		$err = $@;
	} else {
		eval { $code->() };
		$err = $@;
	}

	_run_expectations($plan->{expectations} || [], \%handles);

	my $auto_restore = !exists $plan->{globals}{restore_on_scope_exit}
		|| $plan->{globals}{restore_on_scope_exit};

	Test::Mockingbird::restore_all() if $auto_restore;

	die $err if $err;

	return $wantarray ? @ret : $ret;
}

sub _install_mocks {
	# ENTRY: $mocks is an arrayref of mock spec hashrefs
	#		$handles is a hashref used to store spy/guard handles by tag
	my ($mocks, $handles) = @_;

	# Iterate over each mock specification in the plan
	for my $m (@$mocks) {
		my $target = $m->{target}
		  or croak 'mock entry missing target';

		# Normalize target into ($pkg, $method)
		my ($pkg, $method) = _normalize_target($target);

		# Default type is 'mock' if not provided
		my $type = $m->{type} || 'mock';

		if ($type eq 'mock') {
			# Install a mock, optionally scoped
			my $guard;
			if ($m->{scoped}) {
				$guard = Test::Mockingbird::mock_scoped($pkg, $method, $m->{with});
			} else {
				Test::Mockingbird::mock($pkg, $method, $m->{with});
			}
			# Store guard handle by tag if provided
			$handles->{ $m->{tag} }{guard} = $guard if $m->{tag};
		} elsif ($type eq 'spy') {
			# Install a spy and store its handle by tag
			my $spy = Test::Mockingbird::spy($pkg, $method);
			$handles->{ $m->{tag} }{spy} = $spy if $m->{tag};
		} elsif ($type eq 'inject') {
			# Inject a value or behavior into the target
			Test::Mockingbird::inject($pkg, $method, $m->{with});
			$handles->{ $m->{tag} }{inject} = 1 if $m->{tag};
		} else {
			croak "Unknown mock type '$type' for target '$target'";
		}
	}

	# EXIT: all mocks/spies/injects installed; handles recorded in $handles
}

sub _run_expectations {
	# ENTRY: $exps is an arrayref of expectation hashrefs
	#		$handles is the same hashref populated by _install_mocks
	my ($exps, $handles) = @_;

	# Iterate over each expectation in the plan
	for my $exp (@$exps) {
		my $tag = $exp->{tag}
		  or croak 'expectation missing tag';

		# Look up the spy handle by tag
		my $spy = $handles->{$tag}{spy}
		  or croak "no spy handle for tag '$tag'";

		# Call the spy to retrieve recorded calls
		my @calls = $spy->(); # each call: [ full_method, @args ]

		# Check expected call count if provided
		if (defined $exp->{calls}) {
			Test::More::is(
				scalar(@calls),
				$exp->{calls},
				"DeepMock: calls for $tag"
			);
		}

		# Check argument patterns if args_like is provided
		if (my $args_like = $exp->{args_like}) {
			for my $i (0 .. $#$args_like) {
				my $patterns = $args_like->[$i];
				my $call	 = $calls[$i] || [];
				my @args	 = @$call[1 .. $#$call];  # skip full_method

				for my $j (0 .. $#$patterns) {
					my $re = $patterns->[$j];
					Test::More::like(
						$args[$j],
						ref $re ? $re : qr/$re/,
						"DeepMock: arg $j for call $i of $tag"
					);
				}
			}
		}
	}

	# EXIT: all expectations evaluated via Test::More assertions
}

sub _normalize_target {
	# ENTRY: $arg1 may be 'Package::method' or a package name
	#		$arg2 may be a method name if provided separately
	my ($arg1, $arg2) = @_;

	# If only one arg and it looks like Package::method, split it
	if (defined $arg1 && !defined $arg2 && $arg1 =~ /^(.*)::([^:]+)$/) {
		return ($1, $2);
	}

	# Otherwise, return as-is (package, method)
	return ($arg1, $arg2);

	# EXIT: always returns ($pkg, $method)
}

1;
