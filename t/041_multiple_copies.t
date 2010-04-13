#!/usr/bin/perl

use strict;
use warnings;
use Path::Class;

use lib "t/lib";

use Test::More;
use Test::Exception;
use Test::Moose;

BEGIN {
    use_ok('Test041::Pack');
}

my %copied;
BEGIN {
    package Role::CountCopies;
    use Moose::Role;
    before _copy_entity_recursively => sub {
        my $self = shift;
        my ($file) = @_;
        $copied{$file}++;
    };
    Moose::Util::apply_all_roles($_, __PACKAGE__)
        for qw(
            Test041::Pack
            Test041::Dependency::File1
            Test041::Dependency::File2
            Test041::Dependency::FileDep1
            Test041::Dependency::FileDep2
        );
}

my $pack = Test041::Pack->new;
does_ok($pack, 'Resource::Pack');
does_ok($pack, 'Resource::Pack::Dir');

# copy the file ...

my $dest    = dir('.', 'js');
my @targets = (
    $dest->file( 'packdir.js' ),
    $dest->file( 'File1.js' ),
    $dest->file( 'File2.js' ),
    $dest->file( 'FileDep1.js' ),
    $dest->file( 'FileDep2.js' ),
);

# clear stuff out before we start the test
-e $_ && $_->remove for @targets;
-e $_ && $_->rmtree for $dest;

lives_ok {
    $pack->copy( to => $dest, include_deps => 1 );
} '... directory of resources was copied successfully';

$_->remove for @targets;
$_->rmtree for $dest;

TODO: {
    local $TODO = 'need to figure out the double copy issue';
    is($copied{$_}, 1, "only copied in the file $_ once") for keys %copied;
}

done_testing;


