#!/usr/bin/perl

use strict;
use warnings;
use Path::Class;

use lib "t/lib";

use Test::More;
use Test::Exception;
use Test::Moose;

BEGIN {
    use_ok('Test031::Pack');
}

my $pack = Test031::Pack->new;
does_ok($pack, 'Resource::Pack');
does_ok($pack, 'Resource::Pack::URL');

# copy the file

# copy the file ...

my $dest       = dir('.');
my $target     = $dest->file( 'jquery.min.js' );
my $target_dep = $dest->file( 'PackDep.js' );

# clear stuff out before we start the test
$target->remove     if -e $target;
$target_dep->remove if -e $target_dep;

ok(! -e $target,     '... the file does not exist yet');
ok(! -e $target_dep, '... the dep file does not exist yet');

lives_ok {
    $pack->copy( to => $dest, include_deps => 1 );
} '... file (and deps) was copied successfully';

ok( -e $target,     '... the file does exist now');
ok( -e $target_dep, '... the dep file does exist now');

like( $target->slurp, qr/jQuery JavaScript Library/, '... this looks like jquery to me');
is(($pack->dependencies)[0]->file->slurp, $target_dep->slurp, '... the contents of the dep file are the same');

$target->remove;
$target_dep->remove;

done_testing;

