package Resource::Pack;
use MooseX::Role::Parameterized;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

use Resource::Pack::Types;

parameter 'depends_on' => (
    isa     => 'Resource::Pack::Dependencies',
    default => sub { [] }
);

parameter 'traits' => (
    isa     => 'Resource::Pack::Traits',
    default => sub { [] }
);

role {
    my $p      = shift;
    my $traits = $p->traits;
    my $deps   = [ map { Class::MOP::load_class( $_ ); $_->new } @{ $p->depends_on } ];

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

Resource::Pack - A set of resource management roles that use the CPAN toolchain

=head1 SYNOPSIS

  package My::WebApp::Resources::Javascript;
  use Moose;

  with 'Resource::Pack' => {
      traits => [
          'Resource::Pack::Dir'
      ],
      depends_on => [
          'My::WebApp::Resources::Javascript::Jquery'
      ]
  };

  # now create a lib/My/WebApp/Resources/Javascript/
  # directory and put all your javascript files in it

  package My::WebApp::Resources::Javascript::Jquery;
  use Moose;

  with 'Resource::Pack' => {
      traits => [
          'Resource::Pack::URL' => {
              url => 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js',
          }
      ]
  };

  # this is a dependency of My::WebApp::Resources::Javascript
  # and pulls down the latest jQuery from the google CDN

  # ... later in a setup script for your web-app

  my $js = My::WebApp::Resources::Javascript->new;
  $js->copy(
      to           => '/srv/web_app/htdocs/js/',
      include_deps => 1,
  );

  # this will copy all the javascript files from
  # the lib/My/WebApp/Resources/Javascript/ directory
  # as well as download a copy of jQuery and place
  # it into the same directory

=head1 DESCRIPTION

Resource::Pack is a set of Moose roles designed to make managing non-Perl resources
in a very CPAN friendly way.

In the past if you wanted to distribute your non-Perl code via CPAN there were a number
of less then ideal ways to do it. The simplest was to store the data in Perl strings
or encoded as binary data, this is ugly to say the least. You could also use a module
like L<File::ShareDir>, which relies on the fact that CPAN can be told to install
files inside a directory called F<share>. This technique is both reliable and comes
with a decent set of tools to make accessing these files pretty simple and easy. And
lastly there are tools like L<JS> which installs F<js-cpan> and exploits the fact
that CPAN will also install non-Perl files it finds inside F<lib> along side your
regular Perl files.

So, what does Resource::Pack provide beyond these tools? Mostly it provides a
framework which you can use to inspect and manipulate these non-Perl files, and
most importantly it provides dependency management. Resource::Pack also can
depend on files out on the internet as well and deal with them in the same way
as it does local files.

Resource::Pack currenly uses the L<JS> model and asks that you store your files
inside your F<lib> directory, although it is by no means restricted to this (it
would be quite possible to have it look in the F<share> dir if you were so inclined).

So, this is all the docs I have for now, but more will come soon. This is an
early release of this module so it should still be considered experimental and
so used with caution. As always the best docs are probably the test files.

=head1 METHODS

=over 4

=item B<dependencies>

=item B<applied_traits>

=back

=head1 TODO

=over 4

=item Share directory support

Take a look in L<Resource::Pack::Core> to see where we get the directory
for the resources. Share dir support should be as simple as overriding this.

=item Support for archive/zip files

It would be nice to be able to store a set of files inside an archive of
some kind, and make it just as simple to inspect and unzip that archive. It
would also be nice to allow downloading of zip files from the net.

=item Symlink support

Currently L<Resource::Pack::Util::FileSys> only supports copying files
and directories. It would be nice to also support symlinking to the
original files stored with in the Perl C<@INC> directories.

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
