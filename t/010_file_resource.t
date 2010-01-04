#!/usr/bin/perl

use strict;
use warnings;
use Path::Class;

use lib "t/lib";

use Test::More;
use Test::Exception;
use Test::Moose;

BEGIN {
    use_ok('Test010::Pack');
}

my $pack = Test010::Pack->new;
does_ok($pack, 'Resource::Pack');
does_ok($pack, 'Resource::Pack::File');

is($pack->extension, 'txt', '... the right file extension');

isa_ok($pack->file, 'Path::Class::File');
is($pack->file->basename, 'Pack.txt', '... got the right file basename');

is($pack->file->slurp, 'Test010::Pack', '... got the contents of the file');

# copy the file ...

my $dest   = dir('.');
my $target = $dest->file( 'Pack.txt' );

$target->remove if -e $target; # clear stuff out before we start the test

ok(! -e $target, '... the file does not exist yet');

lives_ok {
    $pack->copy( to => $dest );
} '... file was copied successfully';

ok( -e $target, '... the file does exist now');

is($pack->file->slurp, $target->slurp, '... the contents of the file are the same');

$target->remove;

done_testing;


