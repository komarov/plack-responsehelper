use strict;
use warnings;
use Test::More;
use Test::Deep;

use Plack::ResponseHelper redirect => 'Redirect';

cmp_deeply(
    respond(redirect => '/'),
    [
        302,
        [
            'Location',
            '/'
        ],
        []
    ],
    'ok'
); 

done_testing;
