# NAME

Plack::App::AutoMountPSGI - Auto mount path for psgi files.

# SYNOPSIS

    # app.psgi
    use Plack::App::AutoMountPSGI;

    $app = Plack::App::AutoMountPSGI->new;

    $app->to_app(
        dir => 'example/',
    );

    # run
    example$ plackup 
    mount '/hey' => hey.psgi
    mount '/hello' => hello/app.psgi
    mount '/mount' => mount/app.psgi
    mount '/mount/deep' => mount/deep/app.psgi
    mount '/mount/deep/app2' => mount/deep/app2.psgi
    HTTP::Server::PSGI: Accepting connections at http://0:5000/



# DESCRIPTION

This module is auto mount path for app.psgi.

Mount path is a directry path. And "app.psgi" is root path. ("/")

# EXAMPLE

If this structure and app.psgi there,

    # app.psgi
    use Plack::App::AutoMountPSGI;

    $app = Plack::App::AutoMountPSGI->new;

    $app->to_app( dir => '.' );



    # directory structure
    |- app.psgi # to_app( dir => '.' );
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
