# NAME

PlackX::ResponseHelper

# SYNOPSIS

You can treat it as a micro-framework:

in app.psgi

    use Plack::Request;
    use PlackX::ResponseHelper json => 'JSON',
                               text => 'Text';

    my $app = sub {
        my $env = shift;
        my $form = Plack::Request->new($env)->parameters();
        my $controller = ...;
        respond $controller->($form);
    };

somewhere in your controllers

    sub my_controller {
        ...
        return json => {status => 'ok', data => [1, 2, 3]};
    }

    # or
    sub dummy_controller {
        return text => "It works!";
    }

Or if your app is even less sophisticated, just

    use PlackX::ResponseHelper text => 'Text';
    sub {
        respond text => 'Hello world!';
    }

# DESCRIPTION

A very thin layer that abstracts Plack's specifics.

# METHODS

## use options

    use PlackX::ResponseHelper $type1 => $helper1, ...;

Here you declare your types, it means that you have to use these types
in your calls to `respond`.

`$helper` is short helper's name, a plus sign can be used:

    # will load PlackX::ResponseHelper::JSON
    use PlackX::ResponseHelper json => 'JSON';

    # will load PlackX::ResponseHelper::My::Helper
    use PlackX::ResponseHelper my_helper => '+My::Helper';

## respond

    respond $type => $response;

`respond` is always imported.
Two arguments are required: the type of response and the response itself.

# AUTHORING YOUR OWN HELPERS

Your module just has to contain a `helper` function that returns a coderef
for processing the response data structure that is passed to `respond`.

For more complex helpers you may need to be able to customize their behaviour,
this is achieved by passing an `$init` parameter:

    use PlackX::ResponseHelper my_helper => ['My::Helper', $init];

`$init` can be anything that PX::RH::My::Helper supports, e.g. a code ref
that returns some dynamic data, or just a hashref with configuration options.

    package PlackX::ResponseHelper::My::Helper;

    sub helper {
        my $init = shift;
        my $content_type = $init && $init->{content_type} || 'text/plain';

        return sub {
            my $r = shift;
            return [
                200,
                ['Content-type' => $content_type],
                ['Hello world!']
            ];
        };
    }

    1;

# LICENSE

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
