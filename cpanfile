requires 'perl', '5.008001';
requires 'Path::Tiny';
requires 'Plack';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

