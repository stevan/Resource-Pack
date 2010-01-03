#!/usr/bin/perl

use strict;
use warnings;
use Path::Class;

use lib "t/lib";

use Test::More;
use Test::Exception;
use Test::Moose;

BEGIN {
    use_ok('Test002::Pack');
}

my $pack = Test002::Pack->new;
does_ok($pack, 'Resource::Pack');

my ($dep) = $pack->dependencies;
isa_ok($dep, 'Test002::Dependency::Pack');

done_testing;