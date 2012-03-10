use Test::More;
use Test::Deep;

use Plack::ResponseHelper text => 'Text';

cmp_deeply(
    respond(text => 'abc'),
    [
        200,
        [
            'Content-Type',
            'text/plain'
        ],
        [
            'abc'
        ]
    ],
    'string'
); 

cmp_deeply(
    respond(text => ['abc', 'def']),
    [
        200,
        [
            'Content-Type',
            'text/plain'
        ],
        [
            'abc',
            'def'
        ]
    ],
    'arrayref'
); 

done_testing;
