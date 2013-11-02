package Plack::Builder::AutoDetector;
use 5.008005;
use strict;
use warnings;
use Plack::Util;
use Path::Tiny;

our $VERSION = "0.01";

sub new {
    my $self = bless {}, shift;
}

sub build {
    my $self = shift;
    my %args = @_;

    my @apps;
    my $path = $args{ path } || '.';

    my @app_lib = qw| lib extlib local/lib/perl5 |;
    my $iter = path($path)->iterator;
    while ( my $app_path = $iter->() ) {
        my ($endpoint) = $app_path =~ m/^$path(.*)/;

        my $conf = +{
            endpoint => $endpoint,
            app_path => $app_path . '',
        };
        push( @apps, $conf );
        print "mount '$conf->{endpoint}' => $conf->{app_path}" . $/;
        unshift(@INC, "$app_path/$_") for @app_lib;
    }

    require Plack::Builder;
    Plack::Builder->import;
    for my $conf ( @apps ) {
        my $endpoint = "".$conf->{endpoint};
        mount( $endpoint => $self->build_app($conf->{app_path}) );
    }
}

sub build_app {
    my $self = shift;
    my $path = shift;

    return Plack::Builder::builder {
        Plack::Util::load_psgi("$path/app.psgi");
    };
}

1;
__END__

=encoding utf-8

=head1 NAME

Plack::Builder::AutoDetector - Auto detect mount path for app.psgi.

=head1 SYNOPSIS

    # app.psgi
    use Plack::Builder::AutoDetector;

    $builder = Plack::Builder::AutoDetector->new;

    builder {
        mount '/' => $builder->build(
            path => 'app/',
        );
    };


=head1 DESCRIPTION

Plack::Builder::AutoDetector is auto detect mount path.

Mount path is a directry path.

=head1 EXAMPLE

If this structure and auto_detect.psgi there,

    # auto_detect.psgi
    use Plack::Builder::AutoDetector;

    $builder = Plack::Builder::AutoDetector->new;

    builder {
        mount '/' => $builder->build(
            path => 'app/',
        );
    };


    # directory structure
    |- auto_detect.psgi # build( path => 'app/' );
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

=cut

