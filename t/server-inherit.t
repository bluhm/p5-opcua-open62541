use strict;
use warnings;
use OPCUA::Open62541;

# inherit from server class and check that blessing is correct

package Inherit;
use base 'OPCUA::Open62541::Server';

use Test::More tests => 2;

my $i = Inherit->new();
ok($i, "Inherit new");
is(ref($i), "Inherit", "Inherit bless");
