use strict;
use warnings;

my $lib;
BEGIN {
    use File::Spec;
    $lib = File::Spec->catfile('..', 'lib');
}
use lib $lib;

use App::CrossGate;

my $app = App::CrossGate->new;
$app->to_app( dir => 'apps/' );

