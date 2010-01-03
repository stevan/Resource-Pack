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

ok(! -e $target, '... the file does not exist yet');

lives_ok {
    $pack->copy( to => $dest );
} '... file was copied successfully';

ok( -e $target, '... the file does exist now');

is($pack->file->slurp, $target->slurp, '... the contents of the file are the same');

diag('make a note of the mtime and wait a second ...');

my $mod_time = $target->stat->mtime;
sleep(1);

# see if it will copy ...

lives_ok {
    $pack->copy( to => $dest, checksum => 1 );
} '... file was not copied (because the checksum showed it had not changed)';

is($target->stat->mtime, $mod_time, '... the modification time has not been changed');

# now change the file ...

$target->openw->print('I AM CHANGED NOW');

isnt($target->stat->mtime, $mod_time, '... the modification time have changed (file has been changed)');
isnt($pack->file->slurp, $target->slurp, '... the contents of the file no longer the same');

diag('make a note of the mtime and wait a second ...');

$mod_time = $target->stat->mtime;
sleep(1);

lives_ok {
    $pack->copy( to => $dest, checksum => 1 );
} '... file was copied successfully (because the checksum showed it had changed)';

is($pack->file->slurp, $target->slurp, '... the contents of the file are the same (again)');
isnt($target->stat->mtime, $mod_time, '... the modification time has changed again (file has been copied again)');

diag('make a note of the mtime and wait a second ...');

$mod_time = $target->stat->mtime;
sleep(1);

# and change the file again, but don't change the contents ...

$target->openw->print('Test010::Pack');

isnt($target->stat->mtime, $mod_time, '... the modification time have changed (file has been changed)');
is($pack->file->slurp, $target->slurp, '... the contents of the file now the same');

diag('make a note of the mtime and wait a second ...');

$mod_time = $target->stat->mtime;
sleep(1);

lives_ok {
    $pack->copy( to => $dest, checksum => 1 );
} '... file was not copied (because the checksum showed it had not changed)';

is($target->stat->mtime, $mod_time, '... the modification time has not been changed');

# remove our files ...

$target->remove;

done_testing;


