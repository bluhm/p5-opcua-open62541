use strict;
use warnings;
use OPCUA::Open62541 ':type';

use Test::More tests => 13;
use Test::LeakTrace;
use Test::NoWarnings;
use Test::Warn;

no_leaks_ok {
    my $variant = OPCUA::Open62541::Variant->new();
} "leak variant new";

my $variant = OPCUA::Open62541::Variant->new();
ok($variant, "variant new");

warnings_like { $variant->setScalar(undef, TYPES_SBYTE) }
    (qr/Use of uninitialized value in subroutine entry/, "value undef warn");

warnings_like { $variant->setScalar(1, undef) }
    (qr/Use of uninitialized value in subroutine entry/, "type undef warn");

warnings_like { $variant->setScalar("", TYPES_SBYTE) }
    (qr/Argument "" isn't numeric in subroutine entry/, "value string warn");

warnings_like { $variant->setScalar(1, "") }
    (qr/Argument "" isn't numeric in subroutine entry/, "type string warn");

eval { $variant->setScalar("", TYPES_EVENTNOTIFICATIONLIST) };
ok($@, "scalar TYPES_EVENTNOTIFICATIONLIST");
like($@, qr/type EventNotificationList .* not implemented/, "not implemented");

eval { $variant->setScalar("", OPCUA::Open62541::TYPES_COUNT) };
ok($@, "scalar TYPES_COUNT");
like($@, qr/unsigned value .* not below UA_TYPES_COUNT/, "not below COUNT");

eval { $variant->setScalar("", -1) };
ok($@, "scalar type -1");
like($@, qr/unsigned value .* not below UA_TYPES_COUNT/, "not below -1");
