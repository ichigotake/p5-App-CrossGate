# NAME

App::CrossGate - Multiple application connection gate

# SYNOPSIS

    $ crossgate ./example/apps
    crossgate '/hey' => hey.psgi
    crossgate '/hello' => hello/app.psgi
    crossgate '/mount' => mount/app.psgi
    crossgate '/mount/deep' => mount/deep/app.psgi
    crossgate '/mount/deep/app2' => mount/deep/app2.psgi
    HTTP::Server::PSGI: Accepting connections at http://0:5000/

    # or

    # app.psgi with `plackup`
    use App::CrossGate;
    $app = App::CrossGate->new( dir => './apps' );
    $app->to_app;

    $ plackup

# DESCRIPTION

This module is auto detect path for PSGI applications.

Mount path is a directry path. And "app.psgi" is root path. ("/")

# EXAMPLE

If this structure and app.psgi there,

    # app.psgi
    use App::CrossGate;
    $app = App::CrossGate->new( dir => '.' );
    $app->to_app;

    # directory structure
    |- app.psgi # new( dir => '.' );
    |- hey.psgi
    |- /hello
    |   `- app.psgi
    `- /mount
        |- app.psgi
        `- deep/
            |- app.psgi
            `- app2.psgi

same a following mount path.

    use Plack::Builder;

    builder {
        mount '/hey'             => Plack::Util::load_psgi('hey.psgi');
        mount '/hello'           => Plack::Util::load_psgi('hello/app.psgi');
        mount '/mount'           => Plack::Util::load_psgi('mount/app.psgi');
        mount '/mount/deep'      => Plack::Util::load_psgi('mount/deep/app.psgi');
        mount '/mount/deep/app2' => Plack::Util::load_psgi('mount/deep/app2.psgi');
    };

# SEE ALSO

You can see "example/" directory for example detail.

Plack::Builder

# LICENSE

Copyright (C) ichigotake.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

ichigotake <k.wisiiy@gmail.com>

Special thanks

Songmu
