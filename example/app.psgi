use strict;
use warnings;

my $lib;
BEGIN {
    use File::Spec;
    $lib = File::Spec->catfile('..', 'lib');
}
use lib $lib;


use Plack::App::AutoMountPSGI;

my $app = Plack::App::AutoMountPSGI->new;

use Plack::Builder;
builder {
    mount '/deep' => $app->to_app();
};
