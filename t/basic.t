use Test::More;
use Test::Exception;

use PlackX::ResponseHelper;

dies_ok {
    respond abc => 'abc';
} 'unknown type';

done_testing;
