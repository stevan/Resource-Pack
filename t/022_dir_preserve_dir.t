#!/usr/bin/perl

use strict;
use warnings;
use Path::Class;

use lib "t/lib";

use Test::More;
use Test::Exception;
use Test::Moose;

BEGIN {
    use_ok('Test022::Pack');
}

my $pack = Test022::Pack->new;
does_ok($pack, 'Resource::Pack');
does_ok($pack, 'Resource::Pack::Dir');

# copy the file ...

my $dest     = dir('.');
my $dest_dir = $dest->subdir('Pack');
my @targets = (
    $dest_dir->file( 'test.js' ),
    $dest_dir->file( 'test.css' )
);

# clear stuff out before we start the test
-e $_ && $_->rmtree for $dest_dir;

ok(! -e $_, '... the file (' . $_ . ') does not exist yet') for @targets;

lives_ok {
    $pack->copy( to => $dest, preserve_dir => 1 );
} '... directory of resources was copied successfully';

ok(-e $_, '... the file (' . $_ . ') does exist now') for @targets;

$_->rmtree for $dest_dir;

done_testing;


