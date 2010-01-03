package Resource::Pack::Dir;
use Moose::Role;
use MooseX::Params::Validate;

use Digest::MD5;
use File::Copy ();

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

use Resource::Pack::Types;

with 'Resource::Pack::Core';

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
    my ($to, $include_dependencies, $checksum) = validated_list(\@_,
        to           => { isa => 'Path::Class::Dir', coerce => 1 },
        include_deps => { isa => 'Bool', optional => 1 },
        checksum     => { isa => 'Bool', optional => 1 },
    );

    foreach my $child ( $self->dir->children ) {
        if (-d $child) {
            # TODO:
            # should we just copy the entire sub-directory?
            # - SL
        }
        else {
            my $target = $to->file( $child->basename );

            my $should_copy = 1;

            if ($checksum && -e $target) {
                $should_copy = 0
                    if Digest::MD5->new->addfile( $target->openr )->hexdigest
                    eq Digest::MD5->new->addfile( $child->openr )->hexdigest;
            }

            File::Copy::copy( $child->stringify, $target->stringify  )
                || confess "Could not copy " . $child , " to $target because: $!"
                    if $should_copy;
        }
    }

    if ( $include_dependencies ) {
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
