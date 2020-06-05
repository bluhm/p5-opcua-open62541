use strict;
use warnings;
use OPCUA::Open62541 qw(:TYPES);

use Test::More tests => 12;
use Test::Exception;
use Test::LeakTrace;
use Test::NoWarnings;

ok(my $variant = OPCUA::Open62541::Variant->new(), "variant new");

my %guid = (
    Guid_data1	=> 1,
    Guid_data2	=> 2,
    Guid_data3	=> 3,
    Guid_data4	=> [41 .. 48],
);

no_leaks_ok { $variant->setScalar(\%guid, TYPES_GUID) } "scalar set leak";

ok($variant->isScalar(), "scalar is");
ok(my $guid = $variant->getScalar(), "scalar get");
no_leaks_ok { $variant->getScalar() } "scalar get leak";
is_deeply($guid, \%guid, "guid deep");

%guid = (
    Guid_data4 => [1 .. 100],
    Guid_data5 => 5,
);
$variant->setScalar(\%guid, TYPES_GUID);
is_deeply($variant->getScalar(), {
    Guid_data1 => 0,
    Guid_data2 => 0,
    Guid_data3 => 0,
    Guid_data4 => [1 .. 8],
}, "guid ignore");

%guid = (
    Guid_data1	=> (2**32)-1,
    Guid_data2	=> (2**16)-1,
    Guid_data3	=> (2**16)-1,
    Guid_data4	=> [(255) x 8],
);
$variant->setScalar(\%guid, TYPES_GUID);
is_deeply($variant->getScalar(), \%guid, "guid max");

throws_ok { $variant->setScalar(
    {Guid_data1 => 0, Guid_data4 => [0, 256]}, TYPES_GUID) }
    (qr/Unsigned value 256 greater than UA_BYTE_MAX /, "guid big croak");
no_leaks_ok { eval { $variant->setScalar(
    {Guid_data1 => 0, Guid_data4 => [0, 256]}, TYPES_GUID) } }
    "guid big leak";
is_deeply($variant->getScalar(), \%guid, "guid big");
