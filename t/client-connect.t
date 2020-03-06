use strict;
use warnings;
use OPCUA::Open62541 ':all';

use OPCUA::Open62541::Test::Server;
use Test::More tests => OPCUA::Open62541::Test::Server::planning() + 8;
use Test::NoWarnings;
use Test::Warn;

my $server = OPCUA::Open62541::Test::Server->new();
$server->start();
my $port = $server->port();

ok(my $client = OPCUA::Open62541::Client->new(), "client new");
ok(my $config = $client->getConfig(), "client get config");
is($config->setDefault(), STATUSCODE_GOOD, "client config set default");

my $url = "opc.tcp://localhost:$port";
is($client->connect($url), STATUSCODE_GOOD, "client connect");
is($client->getState, CLIENTSTATE_SESSION, "client state connected");

is($client->disconnect(), STATUSCODE_GOOD, "client disconnect");
is($client->getState, CLIENTSTATE_DISCONNECTED, "client state disconnected");

$server->stop();
