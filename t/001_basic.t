#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Exception;
use Test::Moose;

BEGIN {
    use_ok('Resource::Pack');
}

{
    package My::Pack;
    use Moose;

    with 'Resource::Pack';
}

my $pack = My::Pack->new;
does_ok($pack, 'Resource::Pack');

done_testing;