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
$app->to_app();
