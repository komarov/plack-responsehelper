package Plack::ResponseHelper::JSON;
use strict;
use warnings;

use JSON;
use Plack::Response;

sub helper {
    return sub {
        my $r = shift;
        my $body = to_json $r;
        my $response = Plack::Response->new(200);
        $response->content_type('application/json');
        $response->body($body);
        return $response;
    };
}

1;

__END__

=head1 NAME

Plack::ResponseHelper::JSON

=head1 SEE ALSO

Plack::ResponseHelper

=cut
