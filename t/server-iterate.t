use strict;
use warnings;
use OPCUA::Open62541 ':all';

use Test::More tests => 20;
use Test::LeakTrace;
use Test::NoWarnings;

ok(my $server = OPCUA::Open62541::Server->new(), "server");
ok(my $config = $server->getConfig(), "config");
is($config->setDefault(), STATUSCODE_GOOD, "default");
is($server->run_startup(), STATUSCODE_GOOD, "startup");

cmp_ok($server->run_iterate(0), '>', 0, "iterate");
foreach (1..10) {
    is($server->run_iterate(1), 0, "iterate");
}

is($server->run_shutdown(), STATUSCODE_GOOD, "shutdown");

no_leaks_ok { $server->run_startup() } "startup leak";
no_leaks_ok { $server->run_iterate(0) } "iterate leak";
no_leaks_ok { $server->run_shutdown() } "shutdown leak";
