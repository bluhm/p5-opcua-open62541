use strict;
use warnings;
use OPCUA::Open62541;

use Test::More tests => 11;
use Test::NoWarnings;
use Test::Warn;

my $server = OPCUA::Open62541::Server->new();
ok(defined($server), "server defined");
ok($server, "server new");
is(ref($server), "OPCUA::Open62541::Server", "class");

eval { OPCUA::Open62541::Server::new() };
ok($@, "class missing");
like($@, qr/OPCUA::Open62541::Server::new\(class\) /, "class missing error");

warnings_like { eval { OPCUA::Open62541::Server::new(undef) } }
    (qr/uninitialized value in subroutine entry /, "class undef warning");

eval {
    no warnings 'uninitialized';
    OPCUA::Open62541::Server::new(undef)
};
ok($@, "class undef");
like($@, qr/Class '' is not OPCUA::Open62541::Server /, "class undef error");

eval { OPCUA::Open62541::Server::new("subclass") };
ok($@, "class subclass");
like($@, qr/Class 'subclass' is not OPCUA::Open62541::Server /,
    "class subclass error");
