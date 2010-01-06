#!/usr/bin/perl

use strict;
use warnings;
use Path::Class;

use lib "t/lib";

use Test::More;
use Test::Exception;
use Test::Moose;

BEGIN {
    use_ok('Test021::Pack');
}

my $pack = Test021::Pack->new;
does_ok($pack, 'Resource::Pack');
does_ok($pack, 'Resource::Pack::Dir');

# copy the file ...

my $dest    = dir('.');
my @targets = (
    $dest->file( 'test.js' ),
    $dest->file( 'test.css' )
);
my @dep_targets = (
    $dest->file( 'other_test.js' ),
    $dest->file( 'other_test.css' )
);


# clear stuff out before we start the test
-e $_ && $_->remove for @targets, @dep_targets;

ok(! -e $_, '... the file (' . $_ . ') does not exist yet') for @targets, @dep_targets;

lives_ok {
    $pack->copy( to => $dest, include_deps => 1 );
} '... directory of resources was copied successfully';

ok(-e $_, '... the file (' . $_ . ') does exist now') for @targets, @dep_targets;

$_->remove for @targets, @dep_targets;

done_testing;


