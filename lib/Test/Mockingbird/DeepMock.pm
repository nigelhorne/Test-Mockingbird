package Test::Mockingbird::DeepMock;

use strict;
use warnings;

use Exporter 'import';
use Carp qw(croak);
use Test::Mockingbird ();
use Test::More ();

our @EXPORT_OK = qw(deep_mock);

=head1 NAME

Test::Mockingbird::DeepMock - Declarative, structured mocking and spying for Perl tests

=head1 VERSION

Version 0.04

=cut

our $VERSION = '0.04';

=head1 SYNOPSIS

    use Test::Mockingbird::DeepMock qw(deep_mock);

    {
        package MyApp;
        sub greet  { "hello" }
        sub double { $_[1] * 2 }
    }

    deep_mock(
        {
            mocks => [
                {
                    target => 'MyApp::greet',
                    type   => 'mock',
                    with   => sub { "mocked" },
                }, {
                    target => 'MyApp::double',
                    type   => 'spy',
                    tag    => 'double_spy',
                },
            ], expectations => [
                {
                    tag   => 'double_spy',
                    calls => 2,
                },
            ],
        },
        sub {
            is MyApp::greet(), 'mocked', 'greet() was mocked';

            MyApp::double(2);
            MyApp::double(3);
        }
    );

=head1 DESCRIPTION

C<Test::Mockingbird::DeepMock> provides a declarative, data-driven way to
describe mocking, spying, injection, and expectations in Perl tests.

Instead of scattering C<mock>, C<spy>, and C<restore_all> calls throughout
your test code, DeepMock lets you define a complete mocking plan in a single
hashref, then executes your test code under that plan.

This produces tests that are:

=over 4

=item * easier to read

=item * easier to maintain

=item * easier to extend

=item * easier to reason about

=back

DeepMock is built on top of L<Test::Mockingbird>, adding structure,
expectations, and a clean DSL.

=head1 WHY DEEP MOCK?

Traditional mocking in Perl tends to be:

=over 4

=item * imperative

=item * scattered across the test body

=item * difficult to audit

=item * easy to forget to restore

=back

DeepMock solves these problems by letting you declare everything up front:

    deep_mock(
        {
            mocks        => [...],
            expectations => [...],
        },
        sub { ... }
    );

This gives you:

=over 4

=item * a single place to see all mocks and spies

=item * automatic restore of all mocks

=item * structured expectations

=item * reusable patterns

=item * a clean separation between setup and test logic

=back

=head1 PLAN STRUCTURE

A DeepMock plan is a hashref with the following keys:

=head2 C<mocks>

An arrayref of mock specifications. Each entry is a hashref:

    {
        target => 'Package::method',   # required
        type   => 'mock' | 'spy' | 'inject',
        with   => sub { ... },         # for mock/inject
        tag    => 'identifier',        # for spies or scoped mocks
        scoped => 1,                   # optional
    }

=head3 Types

=over 4

=item C<mock>

Replaces the target method with the provided coderef.

=item C<spy>

Wraps the method and records all calls. Must have a C<tag>.

=item C<inject>

Injects a value or behavior into the target (delegates to C<Test::Mockingbird::inject>).

=back

=head2 C<expectations>

An arrayref of expectation specifications. Each entry is a hashref:

    {
        tag   => 'double_spy',   # required
        calls => 2,              # optional
        args_like => [           # optional
            [ qr/foo/, qr/bar/ ],
        ],
    }

=head3 Expectation fields

=over 4

=item C<tag>

Identifies which spy this expectation applies to.

=item C<calls>

Expected number of calls.

=item C<args_like>

Arrayref of arrayrefs of regexes. Each inner array describes expected
arguments for a specific call.

=back

=head2 C<globals>

Optional hashref controlling global behavior:

    globals => {
        restore_on_scope_exit => 1,   # default
    }

=head1 COOKBOOK

=head2 Mocking a method

    mocks => [
        {
            target => 'MyApp::greet',
            type   => 'mock',
            with   => sub { "hi" },
        },
    ]

=head2 Spying on a method

    mocks => [
        {
            target => 'MyApp::double',
            type   => 'spy',
            tag    => 'dbl',
        },
    ]

=head2 Injecting a dependency

    mocks => [
        {
            target => 'MyApp::Config::get',
            type   => 'inject',
            with   => { debug => 1 },
        },
    ]

=head2 Expecting a call count

    expectations => [
        {
            tag   => 'dbl',
            calls => 3,
        },
    ]

=head2 Expecting argument patterns

    expectations => [
        {
            tag      => 'dbl',
            args_like => [
                [ qr/^\d+$/ ],     # first call
                [ qr/^\d+$/ ],     # second call
            ],
        },
    ]

=head2 Full example

    deep_mock(
        {
            mocks => [
                { target => 'A::foo', type => 'mock', with => sub { 1 } },
                { target => 'A::bar', type => 'spy',  tag => 'bar' },
            ],
            expectations => [
                { tag => 'bar', calls => 2 },
            ],
        },
        sub {
            A::foo();
            A::bar(10);
            A::bar(20);
        }
    );

=head1 TROUBLESHOOTING

=head2 "Not enough arguments for deep_mock"

You are using the BLOCK prototype form:

    deep_mock {
        ...
    }, sub { ... };

This only works if C<deep_mock> has a C<(&$)> prototype AND the first
argument is a real block, not a hashref.

DeepMock uses C<($$)> to avoid Perl's block-vs-hashref ambiguity.

Use parentheses instead:

    deep_mock(
        { ... },
        sub { ... }
    );

=head2 "Type of arg 1 must be block or sub {}"

You are still using the BLOCK prototype form. Switch to parentheses.

=head2 "Use of uninitialized value in multiplication"

Your spied method is being called with no arguments during spy installation.
Make your method robust:

    sub double { ($_[1] // 0) * 2 }

=head2 My mocks aren't restored

Ensure you didn't disable automatic restore:

    globals => { restore_on_scope_exit => 0 }

=head2 Nested deep_mock scopes are not supported

DeepMock installs mocks using L<Test::Mockingbird>, which provides only
global restore semantics via C<restore_all>. Because Test::Mockingbird
does not expose a per-method restore API, DeepMock cannot safely restore
only the mocks installed in an inner scope.

As a result, nested calls like:

    deep_mock { ... } sub {
        deep_mock { ... } sub {
            ...
        };
    };

will cause the inner restore to remove the outer mocks as well.

DeepMock therefore does not support nested mocking scopes.

=cut

sub deep_mock ($$) {
	my ($plan, $code) = @_;

	croak 'deep_mock expects a HASHREF plan' unless ref $plan eq 'HASH';

	my %handles;

	# Install mocks for this scope and capture restore handles
	my @installed = _install_mocks($plan->{mocks} || [], \%handles);

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

	croak $err if $err;

	return $wantarray ? @ret : $ret;
}

# ----------------------------------------------------------------------
# _install_mocks
#
# Installs all mocks/spies/injects declared in the plan.
#
# RETURNS:
#   A list of [ $pkg, $method ] pairs representing the exact methods
#   modified in this deep_mock scope. These are used for per-scope restore.
#
# SIDE EFFECTS:
#   Populates %$handles with spy objects or guards keyed by tag.
#
# NOTES:
#   Test::Mockingbird does not provide mock_scoped() or inject_scoped().
#   Therefore we call the normal global functions and track the modified
#   methods ourselves so we can restore only those on scope exit.
# ----------------------------------------------------------------------
sub _install_mocks {
	my ($mocks, $handles) = @_;

	my @installed;   # list of [$pkg, $method] for this scope

	for my $m (@$mocks) {
		my $target = $m->{target} or croak 'mock entry missing target';

		my ($pkg, $method) = _normalize_target($target);

		my $type = $m->{type} || 'mock';

		if ($type eq 'mock') {
			# --------------------------------------------------------------
			# MOCK
			# --------------------------------------------------------------
			Test::Mockingbird::mock($pkg, $method, $m->{with});

			push @installed, [ $pkg, $method ];

			$handles->{ $m->{tag} }{guard} = 1 if $m->{tag};
		} elsif ($type eq 'spy') {
			# --------------------------------------------------------------
			# SPY
			# --------------------------------------------------------------
			my $spy = Test::Mockingbird::spy($pkg, $method);

			push @installed, [ $pkg, $method ];

			$handles->{ $m->{tag} }{spy} = $spy if $m->{tag};
		} elsif ($type eq 'inject') {
			# --------------------------------------------------------------
			# INJECT
			# --------------------------------------------------------------
			Test::Mockingbird::inject($pkg, $method, $m->{with});

			push @installed, [ $pkg, $method ];

			$handles->{ $m->{tag} }{inject} = 1 if $m->{tag};
		} else {
			croak "Unknown mock type '$type' for target '$target'";
		}
	}

	return @installed;
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

=head1 SUPPORT

This module is provided as-is without any warranty.

Please report any bugs or feature requests to C<bug-test-mockingbird at rt.cpan.org>,
or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-Mockingbird>.
I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

You can find documentation for this module with the perldoc command.

    perldoc Test::Mockingbird::DeepMock

=cut

1;
