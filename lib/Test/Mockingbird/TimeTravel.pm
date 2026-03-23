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

	croak "Invalid timestamp format for TimeTravel: (undef)"
		unless defined $ts && length $ts;

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
