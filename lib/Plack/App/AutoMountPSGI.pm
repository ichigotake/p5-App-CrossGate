package Plack::App::AutoMountPSGI;
use 5.008005;
use strict;
use warnings;
use Plack::Util;
use Path::Tiny;
use Plack::Builder;

our $VERSION = "0.04";

sub new {
    my $self = bless {}, shift;
}

sub to_app {
    my $self = shift;

    Plack::Builder->import;
    builder {
        mount( '/', $self->_build_from_directory );
    };
}

sub _build_from_directory {
    my $self = shift;
    my %args = @_;

    my @apps;
    my $dir = path($args{ dir } || '.');
    my $is_current_dir = $self->_is_current_dir($dir);

    my $iter = $dir->iterator;
    while ( my $app_path = $iter->() ) {
        next unless path("$app_path/app.psgi")->exists;

        my $endpoint;
        if ($is_current_dir) {
            $endpoint = $app_path;
        } else {
            ($endpoint) = $app_path =~ m/^$dir(.*)/;
        }
        $endpoint = '/'.$endpoint unless $endpoint =~ m|^/|;

        my $conf = +{
            endpoint => $endpoint,
            app_path => $app_path . '',
        };
        push( @apps, $conf );
        print "mount '$conf->{endpoint}' => $conf->{app_path}" . $/;
    }

    Plack::Builder->import;
    for my $conf ( @apps ) {
        my $endpoint = "".$conf->{endpoint};
        mount( $endpoint => $self->_build_app($conf->{app_path}) );
    }
}

sub _build_app {
    my $self = shift;
    my $path = shift;

    return Plack::Util::load_psgi("$path/app.psgi");
}

sub _is_current_dir {
    my $self = shift;
    my $dir = shift;
    return path('.')->realpath eq $dir->realpath;
    
}
1;
__END__

=encoding utf-8

=head1 NAME

Plack::App::AutoMountPSGI - Auto mount path for app.psgi.

=head1 SYNOPSIS

    # app.psgi
    use Plack::App::AutoMountPSGI;

    $app = Plack::App::AutoMountPSGI->new;

    $app->to_app(
        dir => 'app/',
    );


=head1 DESCRIPTION

This module is auto mount path for app.psgi.

Mount path is a directry path.

=head1 EXAMPLE

If this structure and auto_detect.psgi there,

    # auto_detect.psgi
    use Plack::App::AutoMountPSGI;

    $app = Plack::App::AutoMountPSGI->new;

    builder {
        mount '/' => $app->to_app(
            dir => 'app/',
        );
    };


    # directory structure
    |- auto_detect.psgi # to_app( dir => 'app/' );
    |
    `- app/
        |
        |- hello/app.psgi
        `- good_morning/app.psgi
        

same a following mount path.

    use Plack::Builder;

    builder {
        mount '/hello' => Plack::Util::load_psgi('hello/app.psgi');
        mount '/good_morning' => Plack::Util::load_psgi('good_morning/app.psgi');
    };

=head1 SEE ALSO

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

