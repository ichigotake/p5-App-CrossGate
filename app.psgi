use strict;
use warnings;
use lib qw/ lib /;
use Plack::Builder;
use Plack::Builder::AutoDetector;

my $builder = Plack::Builder::AutoDetector->new;

builder {
    mount '/' => $builder->run(
        path => File::Spec->catfile('app'),
    );
};
