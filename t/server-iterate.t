use strict;
use warnings;
use OPCUA::Open62541 ':all';

use OPCUA::Open62541::Test::Server;
use Test::More tests => 26;
use Test::LeakTrace;
use Test::NoWarnings;

my $server = OPCUA::Open62541::Test::Server->new();
$server->start();

is($server->{server}->run_startup(), STATUSCODE_GOOD, "startup");

cmp_ok($server->{server}->run_iterate(0), '>', 0, "iterate");
foreach (1..10) {
    is($server->{server}->run_iterate(1), 0, "iterate");
}

is($server->{server}->run_shutdown(), STATUSCODE_GOOD, "shutdown");

no_leaks_ok { $server->{server}->run_startup() } "startup leak";
no_leaks_ok { $server->{server}->run_iterate(0) } "iterate leak";
no_leaks_ok { $server->{server}->run_shutdown() } "shutdown leak";
