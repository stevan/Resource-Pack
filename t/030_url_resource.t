#!/usr/bin/perl

use strict;
use warnings;
use Path::Class;

use Test::More;
use Test::Exception;
use Test::Moose;

{
    package Test030::Pack;
    use Moose;

    with 'Resource::Pack' => {
        traits => [
            'Resource::Pack::URL' => {
                url => 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js'
            }
        ]
    };
}

my $pack = Test030::Pack->new;
does_ok($pack, 'Resource::Pack');
does_ok($pack, 'Resource::Pack::URL');

# copy the file

my $dest   = dir('.');
my $target = $dest->file( 'jquery.min.js' );

$target->remove if -e $target; # clear stuff out before we start the test

ok(! -e $target, '... the file does not exist yet');

lives_ok {
    $pack->copy( to => $dest );
} '... file was copied successfully';

ok( -e $target, '... the file does exist now');

like( $target->slurp, qr/jQuery JavaScript Library/, '... this looks like jquery to me');

$target->remove;

done_testing;

