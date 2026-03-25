#!/usr/bin/env perl

use strict;
use warnings;
use Class::Simple;
use Test::Most;

use Test::Mockingbird;

my $first;
my $second;
mock 'Class::Simple::first_method' => sub { $first++; };
mock 'Class::Simple::second_method' => sub { $second++; };

my $simple = new_ok('Class::Simple');

$simple->first_method();
$simple->second_method();
$simple->second_method();

cmp_ok($first, '==', 1, 'first_method is mocked');
cmp_ok($second, '==', 2, 'second_method is mocked');

done_testing();
