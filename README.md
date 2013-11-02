# NAME

Plack::Builder::AutoDetector - Auto detect mount path for app.psgi.

# SYNOPSIS

    # app.psgi
    use Plack::Builder::AutoDetector;

    $builder = Plack::Builder::AutoDetector->new;

    builder {
        mount '/' => $builder->build(
            path => 'app/',
        );
    };



# DESCRIPTION

Plack::Builder::AutoDetector is auto detect mount path.

Mount path is a directry path.

# EXAMPLE

If this structure and auto\_detect.psgi there,

    # auto_detect.psgi
    use Plack::Builder::AutoDetector;

    $builder = Plack::Builder::AutoDetector->new;

    builder {
        mount '/' => $builder->build(
            path => 'app/',
        );
    };



    # directory structure
    |- auto_detect.psgi # build( path => 'app/' );
    |
    `- app/
        |
        |- hello/app.psgi
        `- good_morning/app.psgi
        



same a following mount path.

    use Plack::Builder;

    builder {
        mount '/hello' => Plack::Util::load_psgi('hello/app.psgi');
        mount '/good_morning' => Plack::Util::load_psgi('good_morning/app.psgi');
    };

# SEE ALSO

Plack::Builder

# LICENSE

Copyright (C) ichigotake.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

ichigotake <k.wisiiy@gmail.com>
