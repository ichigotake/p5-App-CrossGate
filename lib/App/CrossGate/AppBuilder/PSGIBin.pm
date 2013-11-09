package App::CrossGate::AppBuilder::PSGIBin;
use strict;
use warnings;
use utf8;
use parent 'App::CrossGate::AppBuilder::Abstract';
use App::CrossGate::Util;
use File::Basename qw/basename dirname/;
use Path::Tiny;
use Plack::Builder;
use Plack::Util;


sub is_detected {
    my $self = shift;
    my $app_path = shift;

    my $detected;
    my $iter = $app_path->iterator;
    while ( my $file = $iter->() ) {
        if ($self->_is_psgi_file($file)) {
            $detected = 1;
        }
    }

    return $detected;
}

sub _is_psgi_file {
    my $self = shift;
    my $path = shift;
    return 
        -f $path
        && $path =~ m/\.psgi$/
        ;
}

sub build {
    my $self = shift;
    my ($builder, $locate, $locate_dir, $app_path, $caller) = @_;

    my $iter = $app_path->iterator;
    while ( my $file = $iter->() ) {
        if ($self->_is_psgi_file($file)) {
            my $conf = $self->serve_app($locate_dir, $file->realpath, $caller);
            next unless $conf;
            App::CrossGate::Util::show_mount_message($conf);
            $locate->{$conf->{endpoint}} = $conf;
            $builder->mount($conf->{endpoint} => $self->load_app($conf->{app_path}));
        }
    }
}

sub serve_app {
    my $self = shift;
    my ($locate_dir, $app_path, $caller) = @_;

    my $endpoint = dirname($app_path->realpath);
    return unless $endpoint;
    $endpoint =~ s/^$locate_dir//;

    my ($psgi_name) = basename($app_path->realpath) =~ m/(.*)\.psgi/;
    if ('app' ne $psgi_name && basename($app_path->parent) ne $psgi_name) {
        $endpoint .= "/$psgi_name";
    }

    $endpoint = '/'.$endpoint unless $endpoint =~ m|^/|;

    (my $load_app_path = $app_path->realpath)
        =~ s|^$caller->{dirname}/||;

    $load_app_path = path($load_app_path);
    my $app_conf = +{
        endpoint => $endpoint,
        app_path => $load_app_path,
        app_path_relative => $load_app_path->relative($locate_dir),
    };
    return $app_conf;
}

sub load_app {
    my $self = shift;
    my $path = shift;

    return Plack::Util::load_psgi("$path");
}

1;
__DATA__
