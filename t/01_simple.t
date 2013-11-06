use strict;
use warnings;
use Test::More;
use t::Util qw/plackup/;
use HTTP::Request::Common qw/GET/;

plackup('apps/simple', sub {
    my $cb = shift;
    my $res = $cb->(GET '/');
    
    is $res->content, 'This is a simple psgi application.';
});

done_testing;
