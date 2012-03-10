use Test::More;
use Test::Deep;

use Plack::ResponseHelper json => 'JSON';

cmp_deeply(
    respond(json => [{abc => 1}]),
    [
        200,
        [
            'Content-Type',
            'application/json'
        ],
        [
            '[{"abc":1}]'
        ]
    ],
    'ok'
); 

done_testing;
