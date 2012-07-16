package Plack::ResponseHelper::Redirect;
use strict;
use warnings;

use Plack::Response;

sub helper {
    return sub {
        my $r = shift;
        my $response = Plack::Response->new();
        $response->redirect($r);
        return $response;
    };
}

1;

__END__

=head1 NAME

Plack::ResponseHelper::Redirect

=head1 SYNOPSIS

    use Plack::ResponseHelper redirect => 'Redirect';
    respond redirect => $location;

=head1 SEE ALSO

Plack::ResponseHelper

=cut
