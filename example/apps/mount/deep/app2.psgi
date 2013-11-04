use strict;
use warnings;
use Plack::Builder;

builder {
    mount '/path' => sub {
        [200, [], ["mount/deep/app2.psgi#path"]];
    };
    mount '/' => sub {
        [200, [], ["mount/deep/app2.psgi"]];
    };
};
