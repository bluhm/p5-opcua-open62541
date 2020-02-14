use strict;
use warnings;
use OPCUA::Open62541;

use Test::More tests => 2;
use Test::NoWarnings;
use Test::LeakTrace;

no_leaks_ok {
    my $variant = OPCUA::Open62541::Variant->new();
} "leak variant new";
