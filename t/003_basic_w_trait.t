#!/usr/bin/perl

use strict;
use warnings;
use Path::Class;

use lib "t/lib";

use Test::More;
use Test::Exception;
use Test::Moose;

BEGIN {
    use_ok('Resource::Pack');
}

{
    package Test003::Trait;
    use Moose::Role;

    package Test003::Pack;
    use Moose;

    with 'Resource::Pack' => {
        traits => [ 'Test003::Trait' ]
    };
}

my $pack = Test003::Pack->new;
does_ok($pack, 'Resource::Pack');
does_ok($pack, 'Test003::Trait');

is_deeply([ $pack->applied_traits ], [ 'Test003::Trait' ], '... one traits applied');
is_deeply([ $pack->dependencies   ], [], '... no dependencies');

done_testing;