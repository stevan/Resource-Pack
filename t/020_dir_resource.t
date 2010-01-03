#!/usr/bin/perl

use strict;
use warnings;
use Path::Class;

use lib "t/lib";

use Test::More;
use Test::Exception;
use Test::Moose;

BEGIN {
    use_ok('Test020::Pack');
}

my $pack = Test020::Pack->new;
does_ok($pack, 'Resource::Pack');
does_ok($pack, 'Resource::Pack::Dir');

# copy the file ...

my $dest    = dir('.');
my @targets = (
    $dest->file( 'test.js' ),
    $dest->file( 'test.css' )
);

ok(! -e $_,     '... the file (' . $_ . ') does not exist yet') for @targets;

lives_ok {
    $pack->copy( to => $dest );
} '... directory of resources was copied successfully';

ok(-e $_,     '... the file (' . $_ . ') does exist now') for @targets;

$_->remove for @targets;

done_testing;


