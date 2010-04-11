package Resource::Pack::URL;
use MooseX::Role::Parameterized;
use MooseX::Params::Validate;

use LWP::UserAgent;
use URI;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

use Resource::Pack::Types;

parameter 'url' => (
    isa      => 'Str',
    required => 1
);

parameter 'sub_dir' => ( isa => 'Str' );

role {
    my $param = shift;

    my $url     = URI->new( $param->url );
    my $sub_dir = $param->sub_dir;

    with 'Resource::Pack::Core';

    method 'url'         => sub { $url };
    method 'has_sub_dir' => sub { defined $sub_dir ? 1 : 0 };
    method 'sub_dir'     => sub { $sub_dir };
};

sub copy {
    my $self = shift;
    my ($to, $include_dependencies) = validated_list(\@_,
        to           => { isa => 'Path::Class::Dir', coerce => 1 },
        include_deps => { isa => 'Bool', optional => 1 },
    );

    my $response = LWP::UserAgent->new->get( $self->url->as_string );

    if ($response->is_success) {
        if ($self->has_sub_dir) {
            $to = $to->subdir( $self->sub_dir );
        }
        my $fh = $to->file( ($self->url->path_segments)[-1] )->openw;
        $fh->print( $response->content );
        $fh->close;
    }
    else {
        confess "Could not fetch file because : " . $response->status_line;
    }

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
