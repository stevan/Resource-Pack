package Resource::Pack::File;
use MooseX::Role::Parameterized;
use MooseX::Params::Validate;
use MooseX::Types::Path::Class;

use Digest::MD5;
use Class::Inspector;
use Path::Class 'file';
use File::Copy  'copy';

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

with 'Resource::Pack::Core';

parameter 'extension' => (
    isa      => 'Str',
    required => 1,
);

role {
    my $ext = (shift)->extension;

    has 'file' => (
        is       => 'ro',
        isa      => 'Path::Class::File',
        lazy     => 1,
        default  => sub {
            my $class = (shift)->meta->name;
            file( Class::Inspector->loaded_filename( $class ) )
                ->parent
                ->file(  (split /\:\:/ => $class)[-1] . '.' . $ext)
        }
    );

    method 'extension' => sub { $ext };
};

sub copy_file {
    my ($self, $to, $include_dependencies, $checksum) = validated_list(\@_,
        to           => { isa => 'Path::Class::Dir', coerce => 1 },
        include_deps => { isa => 'Bool', optional => 1 },
        checksum     => { isa => 'Bool', optional => 1 },
    );

    my $target = $to->file( $self->file->basename );

    my $should_copy = 1;

    if ($checksum && -e $target) {
        $should_copy = 0
            if Digest::MD5->new->addfile( $target->openr )->hexdigest
            eq Digest::MD5->new->addfile( $self->file->openr )->hexdigest;
    }

    copy( $self->file->stringify, $target->stringify )
        || confess "Could not copy " . $self->file->basename , " to $target because: $!"
            if $should_copy;

    if ( $include_dependencies ) {
        $_->copy_file(
            to           => $to,
            include_deps => 1,
            (defined $checksum ? (checksum => $checksum) : ()),
        ) foreach grep {
            # FIXME:
            # I am not sure about this here ...
            # - SL
            ! $_->does('Resource::Pack::File')
        } $self->dependencies;
    }
}

no Moose::Role; 1;

__END__

=pod

=head1 NAME

Resource::Pack::File - A Moosey solution to this problem

=head1 SYNOPSIS

  use Resource::Pack::File;

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
