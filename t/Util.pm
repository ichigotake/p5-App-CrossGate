package t::Util;
use strict;
use warnings;
use parent 'Exporter';
our @EXPORT_OK = qw/plackup/;

use FindBin;
use Plack::App::AutoMountPSGI;
use Plack::Test;

sub plackup {
    my $dir = shift // die 'you must specifies apps directory path.';
    my $client = shift // die 'you must specifies client callback.';

    my $app = Plack::App::AutoMountPSGI->new->to_app( dir => $FindBin::Bin."/$dir" );
    
    test_psgi
        app => $app,
        client => $client,
    ;
}

1;
