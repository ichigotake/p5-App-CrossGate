use strict;
use warnings;
use Plack::Builder;

builder {
    mount '/' => sub {
        [200, [], ["This is a simple psgi application."]];
    };
};

