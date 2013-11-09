package t::Util;
use strict;
use warnings;
use parent 'Exporter';
our @EXPORT_OK = qw/plackup/;

use FindBin;
use App::CrossGate;
use Plack::Test;

sub plackup {
    my $dir = shift // die 'you must specifies apps directory path.';
    my $client = shift // die 'you must specifies client callback.';

    my $app = App::CrossGate->new( dir => $FindBin::Bin."/$dir" )->to_app;
    
    test_psgi
        app => $app,
        client => $client,
    ;
}

1;
