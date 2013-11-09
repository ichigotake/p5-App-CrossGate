package App::CrossGate;
use 5.008005;
use strict;
use warnings;
use parent 'Plack::Component';
use App::CrossGate::AppBuilder;
use File::Basename qw/dirname/;
use Path::Tiny;
use Plack::Builder;

our $VERSION = "0.05";

sub new {
    my $class = shift;
    my %args = @_;
    my $self = bless {%args}, $class;

    my (undef, $filename, undef) = caller;
    $self->{caller} = {
        filename => $filename,
        dirname  => dirname($filename),
    };

    return $self;
}

sub to_app {
    my $self = shift;

    $self->_locate_apps->to_app;
}

sub _locate_apps {
    my $self = shift;
    my %args = @_;

    my %locate;
    my $builder = Plack::Builder->new;
    my $locate_dir = path($self->{ dir } || '.')->realpath;
    my $appBuilder = App::CrossGate::AppBuilder->new;
    
    # discover for self
    if ($appBuilder->is_detected($locate_dir)) {
        # TODO check again to I/F for reduce arguments.
        $appBuilder->build($builder, \%locate, $locate_dir, $locate_dir, $self->{caller});
    }

    my $iter = $locate_dir->iterator({
        recurse => 1,
        follow_symlinks => 0,
    });
    while ( my $app_path = $iter->() ) {
        next if ! -d $app_path->realpath;
        next if ($locate{$app_path->realpath} || '') =~ m/^$app_path->realpath/;
        next if $self->_caller_is_own($app_path);
        next unless $appBuilder->is_detected($app_path);

        # TODO check again to I/F for reduce arguments.
        $appBuilder->build($builder, \%locate, $locate_dir, $app_path, $self->{caller});
    }

    $self->{locate} = \%locate;

    return $builder;
}

sub _caller_is_own {
    my ($self, $app_path) = @_;
    return $self->{caller}->{filename} eq $app_path->realpath;
}

1;
__END__

=encoding utf-8

=head1 NAME

App::CrossGate - Multiple application connection gate

=head1 SYNOPSIS

    $ crossgate ./example/apps
    crossgate '/hey' => hey.psgi
    crossgate '/hello' => hello/app.psgi
    crossgate '/mount' => mount/app.psgi
    crossgate '/mount/deep' => mount/deep/app.psgi
    crossgate '/mount/deep/app2' => mount/deep/app2.psgi
    HTTP::Server::PSGI: Accepting connections at http://0:5000/

    # or

    # app.psgi with `plackup`
    use App::CrossGate;
    $app = App::CrossGate->new( dir => './apps' );
    $app->to_app;

    $ plackup

=head1 DESCRIPTION

This module is auto detect path for PSGI applications.

Mount path is a directry path. And "app.psgi" is root path. ("/")

=head1 EXAMPLE

If this structure and app.psgi there,

    # app.psgi
    use App::CrossGate;
    $app = App::CrossGate->new( dir => '.' );
    $app->to_app;

    # directory structure
    |- app.psgi # new( dir => '.' );
    |- hey.psgi
    |- /hello
    |   `- app.psgi
    `- /mount
        |- app.psgi
        `- deep/
            |- app.psgi
            `- app2.psgi

same a following mount path.

    use Plack::Builder;

    builder {
        mount '/hey'             => Plack::Util::load_psgi('hey.psgi');
        mount '/hello'           => Plack::Util::load_psgi('hello/app.psgi');
        mount '/mount'           => Plack::Util::load_psgi('mount/app.psgi');
        mount '/mount/deep'      => Plack::Util::load_psgi('mount/deep/app.psgi');
        mount '/mount/deep/app2' => Plack::Util::load_psgi('mount/deep/app2.psgi');
    };

=head1 SEE ALSO

You can see "example/" directory for example detail.

Plack::Builder

=head1 LICENSE

Copyright (C) ichigotake.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ichigotake E<lt>k.wisiiy@gmail.comE<gt>

Special thanks

Songmu

=cut

