package Resource::Pack::Util::FileSys;
use Moose::Role;

use File::Copy::Recursive 'rcopy';

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

sub _copy_entity_recursively {
    my ($self, $entity, $to) = @_;
    my $method = -d $entity ? 'subdir' : 'file';
    my $target = $to->$method( $entity->relative( $entity->parent ) );
    rcopy( $entity->stringify, $target->stringify  )
        || confess "Could not copy $entity to $target because: $!";
}

# TODO:
# support for symlinking
# maybe for archiving
# - SL

no Moose::Role; 1;

__END__

=pod

=head1 NAME

Resource::Pack::Util::FileSys - A Moosey solution to this problem

=head1 SYNOPSIS

  use Resource::Pack::Util::FileSys;

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
