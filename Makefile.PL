use strict;
use warnings;
use inc::Module::Install 0.91;
use Module::Install::AuthorTests;

name 'Resource-Pack';
all_from 'lib/Resource/Pack.pm';
license 'perl';

# prereqs
requires 'Moose'                       => 1.01;
requires 'MooseX::Params::Validate'    => 0.14;
requires 'MooseX::Role::Parameterized' => 0.18;
requires 'Class::Inspector'            => 1.24;
requires 'MooseX::Types::Path::Class'  => 0.05;
requires 'File::Copy::Recursive'       => 0.38;
requires 'Path::Class'                 => 0;
requires 'LWP::UserAgent'              => 0;
requires 'URI'                         => 0;

# things the tests need
build_requires 'Test::More'      => '0.62';
build_requires 'Test::Exception' => '0.21';

tests('t/*.t');
author_tests('t/author/*.t');

WriteAll();

