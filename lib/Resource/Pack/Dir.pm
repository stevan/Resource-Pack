package Resource::Pack::Dir;
use Moose::Role;
use MooseX::Params::Validate;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

use Resource::Pack::Types;

with 'Resource::Pack::Core',
     'Resource::Pack::Util::FileSys';

has 'dir' => (
    is       => 'ro',
    isa      => 'Path::Class::Dir',
    lazy     => 1,
    default  => sub {
        my $self = shift;
        $self->class_file->parent->subdir(
             $self->local_class_name
        )
    }
);

sub copy {
    my $self = shift;
    my ($to, $include_dependencies, $preserve_dir) = validated_list(\@_,
        to           => { isa => 'Path::Class::Dir', coerce => 1 },
        include_deps => { isa => 'Bool', optional => 1 },
        preserve_dir => { isa => 'Bool', optional => 1 },
    );

    my @to_copy = $preserve_dir ? $self->dir : $self->dir->children;

    $self->_copy_entity_recursively( $_, $to ) for @to_copy;

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

Resource::Pack::Dir - A Moosey solution to this problem

=head1 SYNOPSIS

  use Resource::Pack::Dir;

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item B<>

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
