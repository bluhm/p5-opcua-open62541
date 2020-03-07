use strict;
use warnings;
use OPCUA::Open62541;

use Test::More tests => 11;
use Test::NoWarnings;
use Test::Warn;

my $client = OPCUA::Open62541::Client->new();
ok(defined($client), "client defined");
ok($client, "client new");
is(ref($client), "OPCUA::Open62541::Client", "class");

eval { OPCUA::Open62541::Client::new() };
ok($@, "class missing");
like($@, qr/OPCUA::Open62541::Client::new\(class\) /, "class missing error");

warnings_like { eval { OPCUA::Open62541::Client::new(undef) } }
    (qr/uninitialized value in subroutine entry /, "class undef warning");

eval {
    no warnings 'uninitialized';
    OPCUA::Open62541::Client::new(undef)
};
ok($@, "class undef");
like($@, qr/Class '' is not OPCUA::Open62541::Client /, "class undef error");

eval { OPCUA::Open62541::Client::new("subclass") };
ok($@, "class subclass");
like($@, qr/Class 'subclass' is not OPCUA::Open62541::Client /,
    "class subclass error");
