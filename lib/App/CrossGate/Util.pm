package App::CrossGate::Util;
use strict;
use warnings;
use utf8;

sub show_mount_message {
    my $app_conf = shift;

    print "crossgate '$app_conf->{endpoint}' => $app_conf->{app_path_relative}" . $/;
}

1;
__DATA__
