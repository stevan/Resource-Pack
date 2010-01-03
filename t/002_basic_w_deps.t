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
    package Test002::Dependency::Pack;
    use Moose;

    with 'Resource::Pack';

    package Test002::Pack;
    use Moose;

    with 'Resource::Pack' => {
        depends_on => [
            'Test002::Dependency::Pack'
        ]
    };
}

my $pack = Test002::Pack->new;
does_ok($pack, 'Resource::Pack');

my ($dep) = $pack->dependencies;
isa_ok($dep, 'Test002::Dependency::Pack');

is_deeply([ $pack->applied_traits ], [], '... no traits applied');
is_deeply([ $pack->dependencies   ], [ $dep ], '... no dependencies');

done_testing;