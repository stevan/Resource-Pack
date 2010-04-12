package Resource::Pack::File;
use MooseX::Role::Parameterized;
use MooseX::Params::Validate;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

use Resource::Pack::Types;

parameter 'extension' => (
    isa     => 'Str',
    default => 'txt'
);

role {
    my $ext = (shift)->extension;

    with 'Resource::Pack::Core',
         'Resource::Pack::Util::FileSys';

    has 'file' => (
        is       => 'ro',
        isa      => 'Path::Class::File',
        lazy     => 1,
        default  => sub {
            my $self = shift;
            $self->class_file->parent->file(
                 $self->local_class_name
                 . '.'
                 . $self->extension
            )
        }
    );

    method 'extension' => sub { $ext };
};

sub copy {
    my $self = shift;
    my ($to, $include_dependencies) = validated_list(\@_,
        to           => { isa => 'Path::Class::Dir', coerce => 1 },
        include_deps => { isa => 'Bool', optional => 1 },
    );

    $self->_copy_entity_recursively( $self->file, $to );

    if ( $include_dependencies ) {
        # XXX
        # should we check to make sure
        # that it can('copy'). And then
        # should we die if not? or ignore
        # it and go to the next?
        # - SL
        $_->copy( @_ ) foreach $self->dependencies;
    }
}

no Moose::Role; 1;

__END__

=pod

=head1 NAME

Resource::Pack::File

=head1 SYNOPSIS

  use Resource::Pack::File;

=head1 DESCRIPTION

This is parameterized role that can be passed the
extension of the file it should look for.

=head1 ROLE PARAMETERS

=over 4

=item B<extension>

Defaults to C<txt>.

=back

=head1 ATTRIBUTES

=over 4

=item B<file>

=back

=head1 METHODS

=over 4

=item B<extension>

=item B<copy( to => $dir, ?include_deps => 1|0, )>

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
