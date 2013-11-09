package App::CrossGate::AppBuilder;
use strict;
use warnings;
use utf8;
use parent 'App::CrossGate::AppBuilder::Abstract';
use Module::Load;


sub new {
    my $class = shift;
    my $self = bless {}, $class;

    $self->{discovers} //= [
        'PSGIBin',
    ];

    return $self;
}

sub _load {
    my $self = shift;
    my $name = shift;

    my $class = "App::CrossGate::AppBuilder::$name";
    Module::Load::load($class);

    $class->new;
}

sub is_detected {
    my $self = shift;
    my $app_path = shift;

    $self->{current_detector} = undef;
    my $is_detected;
    for my $name (@{$self->{discovers}}) {
        my $detector = $self->_load($name);
        if ($detector->is_detected($app_path)) {
            $self->{current_detector} = $detector;
            $is_detected = 1;
            last;
        }
    }
    
    return $is_detected;
}

sub build {
    my $self = shift;

    $self->{current_detector}->build(@_);
}

1;
__END__

