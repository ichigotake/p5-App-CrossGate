package App::CrossGate::AppBuilder::Abstract;
use strict;
use warnings;
use utf8;

sub new {
    my $class = shift;
    my @args = @_;
    return bless {@args}, $class;
}

sub is_detected { die 'you must overwrite to is_detected().' }

# TODO check again to I/F for reduce arguments.
sub build       { die 'you must overwrite to build($builder, \%locate, $locate_dir, $app_path, $caller).' }


1;
__DATA__

