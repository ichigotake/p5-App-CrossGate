package Plack::App::AutoMountPSGI;
use 5.008005;
use strict;
use warnings;
use Plack::Util;
use Path::Tiny;
use Plack::Builder;

our $VERSION = "0.05";

sub new {
    my $self = bless {}, shift;
}

sub to_app {
    my $self = shift;
    my %args = @_;

    my (undef, $filename, undef) = caller;
    $args{caller} = {
        filename => $filename,
    };

    Plack::Builder->import;
    builder {
        mount( '/', $self->_build_from_directory(%args) );
    };
}

sub _build_from_directory {
    my $self = shift;
    my %args = @_;

    my @apps = $self->_get_app_configs_from_dir(%args);

    for my $conf ( @apps ) {
        print "mount '$conf->{endpoint}' => $conf->{app_path}" . $/;
    }

    Plack::Builder->import;
    for my $conf ( @apps ) {
        mount( $conf->{endpoint} => $self->_build_app($conf->{app_path}) );
    }
}

sub _build_app {
    my $self = shift;
    my $path = shift;

    return Plack::Util::load_psgi("$path");
}

sub _get_app_configs_from_dir {
    my $self = shift;
    my %args = @_;

    my @apps;
    my $iter = path($args{ dir } || '.')->iterator({
        recurse => 1,
        follow_symlinks => 0,
    });
    while ( my $app_path = $iter->() ) {
        
        if ($args{caller}->{filename} eq $app_path->realpath
            || ! -f $app_path
            || $app_path !~ m/\.psgi$/) {
            next;
        }
        my @path = split'/', $app_path;
        my $last_index = scalar(@path)-1;
        my $psgi_file = $path[$last_index];
        my $endpoint = "";
        if (0 != $last_index) {
            $endpoint = join('/', @path[0..($last_index-1)]);
        }
        if ('app.psgi' ne $psgi_file) {
            my ($fname) = $psgi_file =~ m/(.*)\.psgi/;
            $endpoint .= "/$fname";
        }

        $endpoint = '/'.$endpoint unless $endpoint =~ m|^/|;

        my $conf = +{
            endpoint => $endpoint,
            app_path => $app_path,
        };
        push( @apps, $conf );
    }

    return @apps;
}

1;
__END__

=encoding utf-8

=head1 NAME

Plack::App::AutoMountPSGI - Auto mount path for psgi files.

=head1 SYNOPSIS

    # app.psgi
    use Plack::App::AutoMountPSGI;

    $app = Plack::App::AutoMountPSGI->new;

    $app->to_app(
        dir => 'example/',
    );

    # run
    example$ plackup 
    mount '/hey' => hey.psgi
    mount '/hello' => hello/app.psgi
    mount '/mount' => mount/app.psgi
    mount '/mount/deep' => mount/deep/app.psgi
    mount '/mount/deep/app2' => mount/deep/app2.psgi
    HTTP::Server::PSGI: Accepting connections at http://0:5000/


=head1 DESCRIPTION

This module is auto mount path for app.psgi.

Mount path is a directry path. And "app.psgi" is root path. ("/")

=head1 EXAMPLE

If this structure and app.psgi there,

    # app.psgi
    use Plack::App::AutoMountPSGI;

    $app = Plack::App::AutoMountPSGI->new;

    $app->to_app( dir => '.' );


    # directory structure
    |- app.psgi # to_app( dir => '.' );
    |
    |- hey.psgi
    |
    |- /hello
    |   |
    |   `- app.psgi
    |
    `- /mount
        |
        |- app.psgi
        |
        `- deep/
            |
            |- app.psgi
            |
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

