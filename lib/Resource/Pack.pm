package Resource::Pack;
use MooseX::Role::Parameterized;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

use Resource::Pack::Types;

parameter 'depends_on' => (
    isa     => 'Resource::Pack::Dependencies',
    coerce  => 1,
    default => sub { [] }
);

parameter 'traits' => (
    isa     => 'Resource::Pack::Traits',
    default => sub { [] }
);

role {
    my $p      = shift;
    my $traits = $p->traits;
    my $deps   = $p->depends_on;

    # make these constant methods since they won't change
    method 'dependencies'   => sub { @$deps   };
    method 'applied_traits' => sub { @$traits };

    # apply all our traits ...
    with @$traits if @$traits;
};

no MooseX::Role::Parameterized; 1;

__END__

=pod

=head1 NAME

Resource::Pack - A Moosey solution to this problem

=head1 SYNOPSIS

  use Resource::Pack;

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
