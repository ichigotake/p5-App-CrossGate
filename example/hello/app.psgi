use strict;
use warnings;
use Plack::Builder;

builder {
    mount '/' => sub {
        [200, [], ["hello/app.psgi"]];
    };
};
