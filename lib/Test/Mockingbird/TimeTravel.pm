package Test::Mockingbird::TimeTravel;

use strict;
use warnings;

use Carp qw(croak);
use Time::Local qw(timegm);

use Exporter 'import';
our @EXPORT = qw(
	now
	freeze_time
	travel_to
	advance_time
	rewind_time
	restore_all
	with_frozen_time
);

# ----------------------------------------------------------------------
# Internal state
# ----------------------------------------------------------------------

our $ACTIVE		= 0;	  # whether time is frozen
our $CURRENT_EPOCH = undef;  # current simulated time
our $BASE_EPOCH	= undef;  # epoch at moment of freeze

=head1 NAME

Test::Mockingbird::TimeTravel - Deterministic, controllable time for Perl tests

=head1 SYNOPSIS

    use Test::Mockingbird::TimeTravel qw(
        now
        freeze_time
        travel_to
        advance_time
        rewind_time
        restore_all
        with_frozen_time
    );

    # Freeze time at a known point
    freeze_time('2025-01-01T00:00:00Z');
    is now(), 1735689600, 'time is frozen';

    # Move the frozen clock forward
    advance_time(2 => 'minutes');
    is now(), 1735689720, 'time advanced deterministically';

    # Temporarily override time inside a block
    with_frozen_time '2025-01-02T12:00:00Z' => sub {
        is now(), 1735819200, 'block sees overridden time';
    };

    # After the block, the previous frozen time is restored
    is now(), 1735689720, 'outer time restored';

    # Return to real system time
    restore_all();
    isnt now(), 1735689720, 'real time restored';

=head1 DESCRIPTION

C<Test::Mockingbird::TimeTravel> provides a lightweight, deterministic
time-control layer for Perl tests. It allows you to freeze time, move it
forward or backward, jump to specific timestamps, and run code under a
temporary time override - all without touching Perl's built-in C<time()>
or relying on global monkey-patching.

The module is designed for test suites that need:

=over 4

=item *

predictable timestamps

=item *

repeatable behaviour across runs

=item *

clean separation between real time and simulated time

=item *

safe, nestable time overrides

=back

Unlike traditional mocking of C<time()>, TimeTravel does not replace Perl's core functions.
Instead, it provides a dedicated C<now()> function
and a small set of declarative operations that manipulate an internal,
frozen clock. This avoids global side effects and makes time behaviour
explicit in your tests.

=head2 Core Concepts

=over 4

=item * C<now()>

Returns the current simulated time if time is frozen, or the real system
time otherwise.

=item * C<freeze_time>

Freezes time at a specific timestamp. All subsequent calls to C<now()>
return the frozen value until time is restored.

=item * C<travel_to>

Moves the frozen clock to a new timestamp.

=item * C<advance_time> / C<rewind_time>

Moves the frozen clock forward or backward by a duration, expressed in
seconds, minutes, hours, or days.

=item * C<with_frozen_time>

Temporarily overrides time inside a code block, restoring the previous
state afterward - even if the block dies.

=item * C<restore_all>

Restores real time and clears all frozen state.

=back

TimeTravel is fully compatible with L<Test::Mockingbird::DeepMock>, which
can apply time-travel plans declaratively as part of a larger mocking scenario.

=cut

# ----------------------------------------------------------------------
# now()
# ----------------------------------------------------------------------

sub now () {
	return $ACTIVE ? $CURRENT_EPOCH : CORE::time();
}

# ----------------------------------------------------------------------
# Timestamp parsing
# ----------------------------------------------------------------------

sub _parse_timestamp {
	my ($ts) = @_;

	croak 'Invalid timestamp format for TimeTravel: (undef)' unless defined $ts && length $ts;

	# Trim whitespace
	$ts =~ s/^\s+|\s+$//g;

	# Raw epoch
	return $ts if $ts =~ /^\d+$/;

	# ISO8601 UTC: YYYY-MM-DDTHH:MM:SSZ
	if ($ts =~ /^(\d{4})-(\d{2})-(\d{2})T
				 (\d{2}):(\d{2}):(\d{2})
				 Z$/x) {
		return timegm($6,$5,$4,$3,$2-1,$1);
	}

	# Space-separated timestamp: YYYY-MM-DD HH:MM:SS
	if ($ts =~ /^(\d{4})-(\d{2})-(\d{2})\s+
				 (\d{2}):(\d{2}):(\d{2})$/x) {
		return timegm($6,$5,$4,$3,$2-1,$1);
	}

	# Date-only: YYYY-MM-DD → midnight UTC
	if ($ts =~ /^(\d{4})-(\d{2})-(\d{2})$/) {
		return timegm(0,0,0,$3,$2-1,$1);
	}

	croak "Invalid timestamp format for TimeTravel: $ts";
}

# Backwards compatibility for tests
sub _parse_datetime { _parse_timestamp(@_) }

# ----------------------------------------------------------------------
# Unit conversion
# ----------------------------------------------------------------------

sub _unit_to_seconds {
	my ($amount, $unit) = @_;

	# No unit → raw seconds
	return $amount unless defined $unit;

	$unit = lc $unit;

	my %factor = (
		second  => 1,
		seconds => 1,
		minute  => 60,
		minutes => 60,
		hour	=> 3600,
		hours   => 3600,
		day	 => 86400,
		days	=> 86400,
	);

	croak "Unknown time unit '$unit'" unless exists $factor{$unit};

	return $amount * $factor{$unit};
}

# ----------------------------------------------------------------------
# freeze_time()
# ----------------------------------------------------------------------

sub freeze_time {
	my ($ts) = @_;

	$CURRENT_EPOCH = _parse_timestamp($ts);
	$BASE_EPOCH	= $CURRENT_EPOCH;
	$ACTIVE		= 1;

	return $CURRENT_EPOCH;
}

# ----------------------------------------------------------------------
# travel_to()
# ----------------------------------------------------------------------

sub travel_to {
	croak "travel_to() called while TimeTravel is inactive"
		unless $ACTIVE;

	$CURRENT_EPOCH = _parse_timestamp($_[0]);
	return $CURRENT_EPOCH;
}

# ----------------------------------------------------------------------
# advance_time()
# ----------------------------------------------------------------------

sub advance_time {
	croak "advance_time() called while TimeTravel is inactive"
		unless $ACTIVE;

	my ($amount, $unit) = @_;
	my $delta = _unit_to_seconds($amount, $unit);

	$CURRENT_EPOCH += $delta;
	return $CURRENT_EPOCH;
}

# ----------------------------------------------------------------------
# rewind_time()
# ----------------------------------------------------------------------

sub rewind_time {
	croak "rewind_time() called while TimeTravel is inactive"
		unless $ACTIVE;

	my ($amount, $unit) = @_;
	my $delta = _unit_to_seconds($amount, $unit);

	$CURRENT_EPOCH -= $delta;
	return $CURRENT_EPOCH;
}

# ----------------------------------------------------------------------
# restore_all()
# ----------------------------------------------------------------------

sub restore_all {
	$ACTIVE		= 0;
	$CURRENT_EPOCH = undef;
	$BASE_EPOCH	= undef;
}

# ----------------------------------------------------------------------
# with_frozen_time()
# ----------------------------------------------------------------------

sub with_frozen_time {
	my ($ts, $code) = @_;

	croak "with_frozen_time() requires a coderef"
		unless ref($code) eq 'CODE';

	croak "with_frozen_time() requires a timestamp"
		unless defined $ts;

	my $prev_active = $ACTIVE;
	my $prev_epoch  = $CURRENT_EPOCH;
	my $prev_base   = $BASE_EPOCH;

	$CURRENT_EPOCH = _parse_timestamp($ts);
	$BASE_EPOCH	= $CURRENT_EPOCH;
	$ACTIVE		= 1;

	my @ret;
	my $err;

	{
		local $@;
		@ret = eval { $code->() };
		$err = $@;
	}

	$ACTIVE		= $prev_active;
	$CURRENT_EPOCH = $prev_epoch;
	$BASE_EPOCH	= $prev_base;

	die $err if $err;

	return wantarray ? @ret : $ret[0];
}

1;
