package Resource::Pack::Core;
use Moose::Role;

use Class::Inspector;
use Path::Class ();

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

use Resource::Pack::Types;

requires 'dependencies';

has 'fully_qualified_class_name' => (
    is      => 'ro',
    isa     => 'Str',
    default => sub { (shift)->meta->name },
);

has 'local_class_name' => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub {
        ( split /\:\:/ => (shift)->fully_qualified_class_name )[-1]
    },
);

has 'class_file' => (
    is      => 'ro',
    isa     => 'Path::Class::File',
    lazy    => 1,
    default => sub {
        Path::Class::File->new(
            Class::Inspector->loaded_filename(
                (shift)->fully_qualified_class_name
            )
        )
    },
);

no Moose::Role; 1;

__END__

=pod

=head1 NAME

Resource::Pack::Core

=head1 SYNOPSIS

  use Resource::Pack::Core;

=head1 DESCRIPTION

This is a core role which provides some useful attributes to
make it easy to access the files and directories associated
with the class that consumes this role.

=head1 REQUIRED METHODS

=over 4

=item B<dependencies>

=back

=head1 ATTRIBUTES

=over 4

=item B<fully_qualified_class_name>

=item B<local_class_name>

=item B<class_file>

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
