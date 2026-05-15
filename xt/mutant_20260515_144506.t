#!/usr/bin/env perl
# Auto-generated mutant test stubs
# Generated: 2026-05-15 14:45:06
# Generator: scripts/test-generator-index
#
# DO NOT COMMIT without completing the TODO sections.
#
# HIGH/MEDIUM difficulty survivors have TODO stubs — these need real tests.
# LOW difficulty survivors appear as comment hints — worth improving.
#
# Stubs call new() for modules with a constructor, or show a class method
# placeholder for modules without one. Add arguments as needed.

use strict;
use warnings;
use Test::More;

use_ok('Test::Mockingbird');
use_ok('Test::Mockingbird::DeepMock');
use_ok('Test::Mockingbird::TimeTravel');

################################################################
# FILE: lib/Test/Mockingbird.pm
################################################################
# --- SURVIVORS (TODO stubs) ---

# --- SURVIVOR: NUM_BOUNDARY_463_17_> (HIGH) line 463 in mock_scoped() ---
# Source:  } elsif (@args >= 4 && (@args % 2) == 0 && ref($args[1]) eq 'CODE') {
# Hint:    Likely missing edge-case test (boundary value)
# Mutations on this line (4 variants — one test should kill all):
#   Numeric boundary flip >= to >
#   Numeric boundary flip >= to <
#   Numeric boundary flip >= to <=
#   Numeric boundary flip == to !=
TODO: {
    local $TODO = 'Complete: NUM_BOUNDARY_463_17_> line 463 in mock_scoped()';
    # Suggested boundary values to test: 3, 4, 5
    # NOTE: new() called with no arguments as a starting point.
    # If Test::Mockingbird requires constructor arguments, add them here.
    my $obj = new_ok('Test::Mockingbird');
    # TODO: exercise line 463 in mock_scoped() to detect the mutant
    fail('NUM_BOUNDARY_463_17_>: replace with real assertion');
}

# --- SURVIVOR: NUM_BOUNDARY_474_37_!= (HIGH) line 474 in mock_scoped() ---
# Source:  } elsif (@args >= 5 && (@args % 2) == 1 && ref($args[2]) eq 'CODE') {
# Hint:    Likely missing edge-case test (boundary value)
# Mutations on this line (4 variants — one test should kill all):
#   Numeric boundary flip == to !=
#   Numeric boundary flip >= to >
#   Numeric boundary flip >= to <
#   Numeric boundary flip >= to <=
TODO: {
    local $TODO = 'Complete: NUM_BOUNDARY_474_37_!= line 474 in mock_scoped()';
    # Suggested boundary values to test: 4, 5, 6
    # NOTE: new() called with no arguments as a starting point.
    # If Test::Mockingbird requires constructor arguments, add them here.
    my $obj = new_ok('Test::Mockingbird');
    # TODO: exercise line 474 in mock_scoped() to detect the mutant
    fail('NUM_BOUNDARY_474_37_!=: replace with real assertion');
}

# --- SURVIVOR: BOOL_NEGATE_610_3 (MEDIUM) line 610 in spy() ---
# Source:  return $orig->(@_);
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Negate boolean return expression
TODO: {
    local $TODO = 'Complete: BOOL_NEGATE_610_3 line 610 in spy()';
    # NOTE: new() called with no arguments as a starting point.
    # If Test::Mockingbird requires constructor arguments, add them here.
    my $obj = new_ok('Test::Mockingbird');
    # TODO: exercise line 610 in spy() to detect the mutant
    fail('BOOL_NEGATE_610_3: replace with real assertion');
}

# --- SURVIVOR: NUM_BOUNDARY_906_30_!= (HIGH) line 906 in mock_sequence() ---
# Source:  return $queue[0] if @queue == 1;
# Hint:    Likely missing edge-case test (boundary value)
# Mutations on this line (1 variant):
#   Numeric boundary flip == to !=
TODO: {
    local $TODO = 'Complete: NUM_BOUNDARY_906_30_!= line 906 in mock_sequence()';
    # Suggested boundary values to test: 0, 1, 2
    # NOTE: new() called with no arguments as a starting point.
    # If Test::Mockingbird requires constructor arguments, add them here.
    my $obj = new_ok('Test::Mockingbird');
    # TODO: exercise line 906 in mock_sequence() to detect the mutant
    fail('NUM_BOUNDARY_906_30_!=: replace with real assertion');
}

# --- SURVIVOR: COND_INV_1012_3 (MEDIUM) line 1012 in restore() ---
# Source:  if (defined $prev) {
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Invert condition if to unless
TODO: {
    local $TODO = 'Complete: COND_INV_1012_3 line 1012 in restore()';
    # NOTE: new() called with no arguments as a starting point.
    # If Test::Mockingbird requires constructor arguments, add them here.
    my $obj = new_ok('Test::Mockingbird');
    # TODO: exercise line 1012 in restore() to detect the mutant
    fail('COND_INV_1012_3: replace with real assertion');
}

# --- LOW DIFFICULTY HINTS (comment stubs) ---

# --- LOW HINT: RETURN_UNDEF_610_3 line 610 in spy() ---
# Source:  return $orig->(@_);
# Hint:    Mutation survived but impact may be minor
# Mutations on this line (1 variant):
#   Replace return expression with undef
# NOTE: new() called with no arguments as a starting point.
# If Test::Mockingbird requires constructor arguments, add them here.
# my $obj = new_ok('Test::Mockingbird');
# ok($obj->..., 'RETURN_UNDEF_610_3: add assertion here');

################################################################
# FILE: lib/Test/Mockingbird/DeepMock.pm
################################################################
# --- SURVIVORS (TODO stubs) ---

# --- SURVIVOR: COND_INV_610_2 (MEDIUM) line 610 in deep_mock() ---
# Source:  if ($wantarray) {
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Invert condition if to unless
TODO: {
    local $TODO = 'Complete: COND_INV_610_2 line 610 in deep_mock()';
    # NOTE: Test::Mockingbird::DeepMock has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::DeepMock->method(...);
    # TODO: exercise line 610 in deep_mock() to detect the mutant
    fail('COND_INV_610_2: replace with real assertion');
}

# --- SURVIVOR: BOOL_NEGATE_633_2 (MEDIUM) line 633 in deep_mock() ---
# Source:  return $wantarray ? @ret : $ret;
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Negate boolean return expression
TODO: {
    local $TODO = 'Complete: BOOL_NEGATE_633_2 line 633 in deep_mock()';
    # NOTE: Test::Mockingbird::DeepMock has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::DeepMock->method(...);
    # TODO: exercise line 633 in deep_mock() to detect the mutant
    fail('BOOL_NEGATE_633_2: replace with real assertion');
}

# --- SURVIVOR: COND_INV_677_3 (MEDIUM) line 677 in _install_mocks() ---
# Source:  if ($type eq 'mock') {
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Invert condition if to unless
TODO: {
    local $TODO = 'Complete: COND_INV_677_3 line 677 in _install_mocks()';
    # NOTE: Test::Mockingbird::DeepMock has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::DeepMock->method(...);
    # TODO: exercise line 677 in _install_mocks() to detect the mutant
    fail('COND_INV_677_3: replace with real assertion');
}

# --- SURVIVOR: BOOL_NEGATE_711_2 (MEDIUM) line 711 in _install_mocks() ---
# Source:  return @installed;
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Negate boolean return expression
TODO: {
    local $TODO = 'Complete: BOOL_NEGATE_711_2 line 711 in _install_mocks()';
    # NOTE: Test::Mockingbird::DeepMock has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::DeepMock->method(...);
    # TODO: exercise line 711 in _install_mocks() to detect the mutant
    fail('BOOL_NEGATE_711_2: replace with real assertion');
}

# --- SURVIVOR: COND_INV_761_3 (MEDIUM) line 761 in _run_expectations() ---
# Source:  if (defined $exp->{calls}) {
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Invert condition if to unless
TODO: {
    local $TODO = 'Complete: COND_INV_761_3 line 761 in _run_expectations()';
    # NOTE: Test::Mockingbird::DeepMock has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::DeepMock->method(...);
    # TODO: exercise line 761 in _run_expectations() to detect the mutant
    fail('COND_INV_761_3: replace with real assertion');
}

# --- SURVIVOR: COND_INV_772_3 (MEDIUM) line 772 in _run_expectations() ---
# Source:  if (my $args_like = $exp->{args_like}) {
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Invert condition if to unless
TODO: {
    local $TODO = 'Complete: COND_INV_772_3 line 772 in _run_expectations()';
    # NOTE: Test::Mockingbird::DeepMock has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::DeepMock->method(...);
    # TODO: exercise line 772 in _run_expectations() to detect the mutant
    fail('COND_INV_772_3: replace with real assertion');
}

# --- SURVIVOR: COND_INV_792_3 (MEDIUM) line 792 in _run_expectations() ---
# Source:  if (my $args_eq = $exp->{args_eq}) {
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Invert condition if to unless
TODO: {
    local $TODO = 'Complete: COND_INV_792_3 line 792 in _run_expectations()';
    # NOTE: Test::Mockingbird::DeepMock has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::DeepMock->method(...);
    # TODO: exercise line 792 in _run_expectations() to detect the mutant
    fail('COND_INV_792_3: replace with real assertion');
}

# --- SURVIVOR: COND_INV_811_3 (MEDIUM) line 811 in _run_expectations() ---
# Source:  if (my $args_deeply = $exp->{args_deeply}) {
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Invert condition if to unless
TODO: {
    local $TODO = 'Complete: COND_INV_811_3 line 811 in _run_expectations()';
    # NOTE: Test::Mockingbird::DeepMock has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::DeepMock->method(...);
    # TODO: exercise line 811 in _run_expectations() to detect the mutant
    fail('COND_INV_811_3: replace with real assertion');
}

# --- SURVIVOR: COND_INV_831_3 (MEDIUM) line 831 in _run_expectations() ---
# Source:  if ($exp->{never}) {
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Invert condition if to unless
TODO: {
    local $TODO = 'Complete: COND_INV_831_3 line 831 in _run_expectations()';
    # NOTE: Test::Mockingbird::DeepMock has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::DeepMock->method(...);
    # TODO: exercise line 831 in _run_expectations() to detect the mutant
    fail('COND_INV_831_3: replace with real assertion');
}

# --- SURVIVOR: COND_INV_872_2 (MEDIUM) line 872 in _normalize_target() ---
# Source:  if (defined $arg1 && !defined $arg2 && $arg1 =~ /^(.*)::([^:]+)$/) {
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Invert condition if to unless
TODO: {
    local $TODO = 'Complete: COND_INV_872_2 line 872 in _normalize_target()';
    # NOTE: Test::Mockingbird::DeepMock has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::DeepMock->method(...);
    # TODO: exercise line 872 in _normalize_target() to detect the mutant
    fail('COND_INV_872_2: replace with real assertion');
}

# --- SURVIVOR: COND_INV_886_2 (MEDIUM) line 886 in _apply_time_plan() ---
# Source:  if (exists $time->{freeze}) {
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Invert condition if to unless
TODO: {
    local $TODO = 'Complete: COND_INV_886_2 line 886 in _apply_time_plan()';
    # NOTE: Test::Mockingbird::DeepMock has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::DeepMock->method(...);
    # TODO: exercise line 886 in _apply_time_plan() to detect the mutant
    fail('COND_INV_886_2: replace with real assertion');
}

# --- SURVIVOR: COND_INV_890_2 (MEDIUM) line 890 in _apply_time_plan() ---
# Source:  if (exists $time->{travel}) {
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Invert condition if to unless
TODO: {
    local $TODO = 'Complete: COND_INV_890_2 line 890 in _apply_time_plan()';
    # NOTE: Test::Mockingbird::DeepMock has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::DeepMock->method(...);
    # TODO: exercise line 890 in _apply_time_plan() to detect the mutant
    fail('COND_INV_890_2: replace with real assertion');
}

# --- SURVIVOR: COND_INV_894_2 (MEDIUM) line 894 in _apply_time_plan() ---
# Source:  if (exists $time->{advance}) {
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Invert condition if to unless
TODO: {
    local $TODO = 'Complete: COND_INV_894_2 line 894 in _apply_time_plan()';
    # NOTE: Test::Mockingbird::DeepMock has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::DeepMock->method(...);
    # TODO: exercise line 894 in _apply_time_plan() to detect the mutant
    fail('COND_INV_894_2: replace with real assertion');
}

# --- SURVIVOR: COND_INV_899_2 (MEDIUM) line 899 in _apply_time_plan() ---
# Source:  if (exists $time->{rewind}) {
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Invert condition if to unless
TODO: {
    local $TODO = 'Complete: COND_INV_899_2 line 899 in _apply_time_plan()';
    # NOTE: Test::Mockingbird::DeepMock has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::DeepMock->method(...);
    # TODO: exercise line 899 in _apply_time_plan() to detect the mutant
    fail('COND_INV_899_2: replace with real assertion');
}

# --- LOW DIFFICULTY HINTS (comment stubs) ---

# --- LOW HINT: RETURN_UNDEF_633_2 line 633 in deep_mock() ---
# Source:  return $wantarray ? @ret : $ret;
# Hint:    Mutation survived but impact may be minor
# Mutations on this line (1 variant):
#   Replace return expression with undef
# NOTE: Test::Mockingbird::DeepMock has no constructor — call class methods directly.
# e.g. my $result = Test::Mockingbird::DeepMock->method(...);
# ok($result, 'RETURN_UNDEF_633_2: add assertion here');

# --- LOW HINT: RETURN_UNDEF_711_2 line 711 in _install_mocks() ---
# Source:  return @installed;
# Hint:    Mutation survived but impact may be minor
# Mutations on this line (1 variant):
#   Replace return expression with undef
# NOTE: Test::Mockingbird::DeepMock has no constructor — call class methods directly.
# e.g. my $result = Test::Mockingbird::DeepMock->method(...);
# ok($result, 'RETURN_UNDEF_711_2: add assertion here');

################################################################
# FILE: lib/Test/Mockingbird/TimeTravel.pm
################################################################
# --- SURVIVORS (TODO stubs) ---

# --- SURVIVOR: BOOL_NEGATE_245_2 (MEDIUM) line 245 in now() ---
# Source:  return $ACTIVE ? $CURRENT_EPOCH : CORE::time();
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Negate boolean return expression
TODO: {
    local $TODO = 'Complete: BOOL_NEGATE_245_2 line 245 in now()';
    # NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
    # TODO: exercise line 245 in now() to detect the mutant
    fail('BOOL_NEGATE_245_2: replace with real assertion');
}

# --- SURVIVOR: BOOL_NEGATE_359_2 (MEDIUM) line 359 in freeze_time() ---
# Source:  return $CURRENT_EPOCH;
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Negate boolean return expression
TODO: {
    local $TODO = 'Complete: BOOL_NEGATE_359_2 line 359 in freeze_time()';
    # NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
    # TODO: exercise line 359 in freeze_time() to detect the mutant
    fail('BOOL_NEGATE_359_2: replace with real assertion');
}

# --- SURVIVOR: BOOL_NEGATE_476_2 (MEDIUM) line 476 in travel_to() ---
# Source:  return $CURRENT_EPOCH;
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Negate boolean return expression
TODO: {
    local $TODO = 'Complete: BOOL_NEGATE_476_2 line 476 in travel_to()';
    # NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
    # TODO: exercise line 476 in travel_to() to detect the mutant
    fail('BOOL_NEGATE_476_2: replace with real assertion');
}

# --- SURVIVOR: BOOL_NEGATE_604_2 (MEDIUM) line 604 in advance_time() ---
# Source:  return $CURRENT_EPOCH;
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Negate boolean return expression
TODO: {
    local $TODO = 'Complete: BOOL_NEGATE_604_2 line 604 in advance_time()';
    # NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
    # TODO: exercise line 604 in advance_time() to detect the mutant
    fail('BOOL_NEGATE_604_2: replace with real assertion');
}

# --- SURVIVOR: BOOL_NEGATE_731_2 (MEDIUM) line 731 in rewind_time() ---
# Source:  return $CURRENT_EPOCH;
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Negate boolean return expression
TODO: {
    local $TODO = 'Complete: BOOL_NEGATE_731_2 line 731 in rewind_time()';
    # NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
    # TODO: exercise line 731 in rewind_time() to detect the mutant
    fail('BOOL_NEGATE_731_2: replace with real assertion');
}

# --- SURVIVOR: BOOL_NEGATE_981_2 (MEDIUM) line 981 in with_frozen_time() ---
# Source:  return wantarray ? @ret : $ret[0];
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Negate boolean return expression
TODO: {
    local $TODO = 'Complete: BOOL_NEGATE_981_2 line 981 in with_frozen_time()';
    # NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
    # TODO: exercise line 981 in with_frozen_time() to detect the mutant
    fail('BOOL_NEGATE_981_2: replace with real assertion');
}

# --- SURVIVOR: BOOL_NEGATE_1021_2 (MEDIUM) line 1021 in _parse_timestamp() ---
# Source:  return $ts if $ts =~ /^\d+$/;
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Negate boolean return expression
TODO: {
    local $TODO = 'Complete: BOOL_NEGATE_1021_2 line 1021 in _parse_timestamp()';
    # NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
    # TODO: exercise line 1021 in _parse_timestamp() to detect the mutant
    fail('BOOL_NEGATE_1021_2: replace with real assertion');
}

# --- SURVIVOR: COND_INV_1024_2 (MEDIUM) line 1024 in _parse_timestamp() ---
# Source:  if ($ts =~ /^(\d{4})-(\d{2})-(\d{2})T
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Invert condition if to unless
TODO: {
    local $TODO = 'Complete: COND_INV_1024_2 line 1024 in _parse_timestamp()';
    # NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
    # TODO: exercise line 1024 in _parse_timestamp() to detect the mutant
    fail('COND_INV_1024_2: replace with real assertion');
}

# --- SURVIVOR: COND_INV_1031_2 (MEDIUM) line 1031 in _parse_timestamp() ---
# Source:  if ($ts =~ /^(\d{4})-(\d{2})-(\d{2})\s+
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Invert condition if to unless
TODO: {
    local $TODO = 'Complete: COND_INV_1031_2 line 1031 in _parse_timestamp()';
    # NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
    # TODO: exercise line 1031 in _parse_timestamp() to detect the mutant
    fail('COND_INV_1031_2: replace with real assertion');
}

# --- SURVIVOR: COND_INV_1037_2 (MEDIUM) line 1037 in _parse_timestamp() ---
# Source:  if ($ts =~ /^(\d{4})-(\d{2})-(\d{2})$/) {
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Invert condition if to unless
TODO: {
    local $TODO = 'Complete: COND_INV_1037_2 line 1037 in _parse_timestamp()';
    # NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
    # TODO: exercise line 1037 in _parse_timestamp() to detect the mutant
    fail('COND_INV_1037_2: replace with real assertion');
}

# --- SURVIVOR: BOOL_NEGATE_1080_2 (MEDIUM) line 1080 in _unit_to_seconds() ---
# Source:  return $amount unless defined $unit;
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Negate boolean return expression
TODO: {
    local $TODO = 'Complete: BOOL_NEGATE_1080_2 line 1080 in _unit_to_seconds()';
    # NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
    # TODO: exercise line 1080 in _unit_to_seconds() to detect the mutant
    fail('BOOL_NEGATE_1080_2: replace with real assertion');
}

# --- SURVIVOR: BOOL_NEGATE_1097_2 (MEDIUM) line 1097 in _unit_to_seconds() ---
# Source:  return $amount * $factor{$unit};
# Hint:    Add tests asserting both true and false outcomes
# Mutations on this line (1 variant):
#   Negate boolean return expression
TODO: {
    local $TODO = 'Complete: BOOL_NEGATE_1097_2 line 1097 in _unit_to_seconds()';
    # NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
    # e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
    # TODO: exercise line 1097 in _unit_to_seconds() to detect the mutant
    fail('BOOL_NEGATE_1097_2: replace with real assertion');
}

# --- LOW DIFFICULTY HINTS (comment stubs) ---

# --- LOW HINT: RETURN_UNDEF_245_2 line 245 in now() ---
# Source:  return $ACTIVE ? $CURRENT_EPOCH : CORE::time();
# Hint:    Mutation survived but impact may be minor
# Mutations on this line (1 variant):
#   Replace return expression with undef
# NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
# e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
# ok($result, 'RETURN_UNDEF_245_2: add assertion here');

# --- LOW HINT: RETURN_UNDEF_359_2 line 359 in freeze_time() ---
# Source:  return $CURRENT_EPOCH;
# Hint:    Mutation survived but impact may be minor
# Mutations on this line (1 variant):
#   Replace return expression with undef
# NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
# e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
# ok($result, 'RETURN_UNDEF_359_2: add assertion here');

# --- LOW HINT: RETURN_UNDEF_476_2 line 476 in travel_to() ---
# Source:  return $CURRENT_EPOCH;
# Hint:    Mutation survived but impact may be minor
# Mutations on this line (1 variant):
#   Replace return expression with undef
# NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
# e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
# ok($result, 'RETURN_UNDEF_476_2: add assertion here');

# --- LOW HINT: RETURN_UNDEF_604_2 line 604 in advance_time() ---
# Source:  return $CURRENT_EPOCH;
# Hint:    Mutation survived but impact may be minor
# Mutations on this line (1 variant):
#   Replace return expression with undef
# NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
# e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
# ok($result, 'RETURN_UNDEF_604_2: add assertion here');

# --- LOW HINT: RETURN_UNDEF_731_2 line 731 in rewind_time() ---
# Source:  return $CURRENT_EPOCH;
# Hint:    Mutation survived but impact may be minor
# Mutations on this line (1 variant):
#   Replace return expression with undef
# NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
# e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
# ok($result, 'RETURN_UNDEF_731_2: add assertion here');

# --- LOW HINT: RETURN_UNDEF_981_2 line 981 in with_frozen_time() ---
# Source:  return wantarray ? @ret : $ret[0];
# Hint:    Mutation survived but impact may be minor
# Mutations on this line (1 variant):
#   Replace return expression with undef
# NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
# e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
# ok($result, 'RETURN_UNDEF_981_2: add assertion here');

# --- LOW HINT: RETURN_UNDEF_1021_2 line 1021 in _parse_timestamp() ---
# Source:  return $ts if $ts =~ /^\d+$/;
# Hint:    Mutation survived but impact may be minor
# Mutations on this line (1 variant):
#   Replace return expression with undef
# NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
# e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
# ok($result, 'RETURN_UNDEF_1021_2: add assertion here');

# --- LOW HINT: RETURN_UNDEF_1080_2 line 1080 in _unit_to_seconds() ---
# Source:  return $amount unless defined $unit;
# Hint:    Mutation survived but impact may be minor
# Mutations on this line (1 variant):
#   Replace return expression with undef
# NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
# e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
# ok($result, 'RETURN_UNDEF_1080_2: add assertion here');

# --- LOW HINT: RETURN_UNDEF_1097_2 line 1097 in _unit_to_seconds() ---
# Source:  return $amount * $factor{$unit};
# Hint:    Mutation survived but impact may be minor
# Mutations on this line (1 variant):
#   Replace return expression with undef
# NOTE: Test::Mockingbird::TimeTravel has no constructor — call class methods directly.
# e.g. my $result = Test::Mockingbird::TimeTravel->method(...);
# ok($result, 'RETURN_UNDEF_1097_2: add assertion here');

done_testing();
