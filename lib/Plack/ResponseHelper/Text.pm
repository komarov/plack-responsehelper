package Plack::ResponseHelper::Text;
use strict;
use warnings;

use Plack::Response;

sub helper {
    return sub {
        my $r = shift;
        my $response = Plack::Response->new(200);
        $response->content_type('text/plain');
        $response->body($r);
        return $response;
    };
}

1;

__END__

=head1 NAME

Plack::ResponseHelper::Text

=head1 SEE ALSO

Plack::ResponseHelper

=cut

