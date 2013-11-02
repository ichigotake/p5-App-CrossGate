use strict;
use warnings;

my $lib;
BEGIN {
    use File::Spec;
    $lib = File::Spec->catfile('..', 'lib');
}
use lib $lib;

use Plack::Builder;
use Plack::Builder::AutoDetector;

my $builder = Plack::Builder::AutoDetector->new;

builder {
    mount '/' => $builder->build();
};
