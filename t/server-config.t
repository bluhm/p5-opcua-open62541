use strict;
use warnings;
use OPCUA::Open62541;

use Test::More tests => 21;
use Test::Exception;
use Test::LeakTrace;
use Test::NoWarnings;
use Test::Warn;

ok(my $server1 = OPCUA::Open62541::Server->new(), "server1 new");
ok(my $config = $server1->getConfig(), "config get");
is(ref($config), "OPCUA::Open62541::ServerConfig", "config class");

my $server2 = OPCUA::Open62541::Server->newWithConfig($config);
ok(defined($server2), "server2 defined");
ok($server2, "server2 new");
is(ref($server2), "OPCUA::Open62541::Server", "server2 class");
no_leaks_ok { OPCUA::Open62541::Server->newWithConfig($config) }
    "leak server2";

throws_ok { OPCUA::Open62541::Server::newWithConfig() }
    (qr/OPCUA::Open62541::Server::newWithConfig\(class, config\) /,
    "class missing");
no_leaks_ok { eval { OPCUA::Open62541::Server::newWithConfig() } }
    "leak class missing";

throws_ok { OPCUA::Open62541::Server->newWithConfig() }
    (qr/OPCUA::Open62541::Server::newWithConfig\(class, config\) /,
    "config missing");
no_leaks_ok { eval { OPCUA::Open62541::Server->newWithConfig() } }
    "leak config missing";

warnings_like {
    throws_ok { OPCUA::Open62541::Server::newWithConfig(undef, $config) }
	(qr/Class '' is not OPCUA::Open62541::Server /, "class undef");
} (qr/uninitialized value in subroutine entry /, "class undef warning");
no_leaks_ok {
    no warnings 'uninitialized';
    eval { OPCUA::Open62541::Server::newWithConfig(undef, $config) }
} "leak class undef";

throws_ok { OPCUA::Open62541::Server->newWithConfig(undef) }
    (qr/config is not of type OPCUA::Open62541::ServerConfig /,
    "config undef");
no_leaks_ok { eval { OPCUA::Open62541::Server->newWithConfig(undef) } }
    "leak config undef";

throws_ok { OPCUA::Open62541::Server->newWithConfig($server1) }
    (qr/config is not of type OPCUA::Open62541::ServerConfig /,
    "config type");
no_leaks_ok { eval { OPCUA::Open62541::Server->newWithConfig($server1) } }
    "leak config type";

throws_ok { OPCUA::Open62541::Server::newWithConfig("subclass", $config) }
    (qr/Class 'subclass' is not OPCUA::Open62541::Server /, "class subclass");
no_leaks_ok {
    eval { OPCUA::Open62541::Server::newWithConfig("subclass", $config) }
} "leak class subclass";
