use strict;
use warnings;
use OPCUA::Open62541;

use Test::More tests => 20;
use Test::NoWarnings;
use Test::Warn;

ok(my $server1 = OPCUA::Open62541::Server->new(), "server1 new");
ok(my $config = $server1->getConfig(), "config get");
is(ref($config), "OPCUA::Open62541::ServerConfig", "config class");

my $server2 = OPCUA::Open62541::Server->newWithConfig($config);
ok(defined($server2), "server2 defined");
ok($server2, "server2 new");
is(ref($server2), "OPCUA::Open62541::Server", "server2 class");

eval { OPCUA::Open62541::Server::newWithConfig() };
ok($@, "class missing");
like($@, qr/OPCUA::Open62541::Server::newWithConfig\(class, config\) /,
    "class missing error");

eval { OPCUA::Open62541::Server->newWithConfig() };
ok($@, "config missing");
like($@, qr/OPCUA::Open62541::Server::newWithConfig\(class, config\) /,
    "config missing error");

warnings_like {
    eval { OPCUA::Open62541::Server::newWithConfig(undef, $config) }
} (qr/uninitialized value in subroutine entry /, "class undef warning");

eval {
    no warnings 'uninitialized';
    OPCUA::Open62541::Server::newWithConfig(undef, $config)
};
ok($@, "class undef");
like($@, qr/Class '' is not OPCUA::Open62541::Server /, "class undef error");

eval { OPCUA::Open62541::Server->newWithConfig(undef) };
ok($@, "config undef");
like($@, qr/config is not of type OPCUA::Open62541::ServerConfig /,
    "config undef error");

eval { OPCUA::Open62541::Server->newWithConfig($server1) };
ok($@, "config type");
like($@, qr/config is not of type OPCUA::Open62541::ServerConfig /,
    "config type error");

eval { OPCUA::Open62541::Server::newWithConfig("subclass", $config) };
ok($@, "class subclass");
like($@, qr/Class 'subclass' is not OPCUA::Open62541::Server /,
    "class subclass error");
