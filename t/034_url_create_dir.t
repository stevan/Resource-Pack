#!/usr/bin/perl

use strict;
use warnings;
use Path::Class;

use Test::More;
use Test::Exception;
use Test::Moose;

{
    package Test034::Pack;
    use Moose;

    with 'Resource::Pack' => {
        traits => [
            'Resource::Pack::URL' => {
                url     => 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js',
                sub_dir => 'js'
            }
        ]
    };
}

my $pack = Test034::Pack->new;
does_ok($pack, 'Resource::Pack');
does_ok($pack, 'Resource::Pack::URL');

# copy the file

my $dest   = dir('.');
my $target = $dest->subdir('js')->file( 'jquery.min.js' );

$target->remove if -e $target; # clear stuff out before we start the test
-e $_ && $_->rmtree for $dest->subdir('js');

ok(! -e $target, '... the file does not exist yet');

lives_ok {
    $pack->copy( to => $dest );
} '... file was copied successfully';

ok( -e $dest->subdir('js'), '... the folder does exist now');
ok( -e $target, '... the file does exist now');

like( $target->slurp, qr/jQuery JavaScript Library/, '... this looks like jquery to me');

$target->remove;
$_->rmtree for $dest->subdir('js');

done_testing;

