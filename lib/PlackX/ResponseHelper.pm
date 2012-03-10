package PlackX::ResponseHelper;
use strict;
use warnings;
use Carp;

our $HELPERS = {};

sub import {
    shift;
    my %options = @_;
    foreach my $type (keys %options) {
        my ($helper, $init) = ref $options{$type} 
                              ? @{$options{$type}}
                              : ($options{$type}, undef);

        $helper =~ s/^\+//;
        croak "bad helper name $helper" unless $helper =~ /^\w+(?:::\w+)*$/;

        my $package = "PlackX::ResponseHelper::$helper";
        eval "require $package" or croak $@;

        no strict 'refs';
        my $code = *{$package.'::helper'}->($init);
        $HELPERS->{$type} = $code;
    }

    my $pkg = caller;
    no strict 'refs';
    *{$pkg.'::respond'} = \&respond;
}

sub respond($$) {
    my $type = shift;
    my $r = shift;

    croak "unknown type '$type'" unless exists $HELPERS->{$type};
    $r = $HELPERS->{$type}->($r);

    if (ref $r =~ /^(?:ARRAY|CODE)$/) {
        return $r;
    }
    if (UNIVERSAL::isa($r, "Plack::Response")) {
        return $r->finalize();
    }

    croak "bad response";
}

1;
__END__

=head1 NAME
    
PlackX::ResponseHelper

=head1 SYNOPSIS

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

=head1 DESCRIPTION

A very thin layer that abstracts Plack's specifics.

=head1 METHODS

=head2 use options

    use PlackX::ResponseHelper $type => $helper;

Here you declare your types, it means that you have to use these types
in your calls to C<respond>.

C<< $helper >> is short helper's name, a plus sign can be used:
    # will load PlackX::ResponseHelper::JSON
    use PlackX::ResponseHelper json => 'JSON';

    # will load PlackX::ResponseHelper::My::Helper
    use PlackX::ResponseHelper my_helper => '+My::Helper';

=head2 respond

    respond $type => $response;

C<respond> is always imported.
Two arguments are required: the type of response and the response itself.

=head1 LICENSE

This module is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
