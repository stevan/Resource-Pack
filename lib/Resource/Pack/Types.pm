package Resource::Pack::Types;
use Moose;
use Moose::Util::TypeConstraints;
use MooseX::Types::Path::Class;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

subtype 'Resource::Pack::Dependencies'
    => as 'ArrayRef[ Str | ClassName ]';

subtype 'Resource::Pack::Traits'
    => as 'ArrayRef[ Str | RoleName | HashRef ]';

no Moose; no Moose::Util::TypeConstraints; 1;

__END__

=pod

=head1 NAME

Resource::Pack::Types - The type library for Resource::Pack;

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
