use strict;
use warnings;
use OPCUA::Open62541 qw(:STATUSCODE :CLIENTSTATE);

use OPCUA::Open62541::Test::Server;
use OPCUA::Open62541::Test::Client;
use Test::More;
BEGIN {
    if (OPCUA::Open62541::Client->can('disconnectAsync')) {
	plan tests =>
	    OPCUA::Open62541::Test::Server::planning() +
	    OPCUA::Open62541::Test::Client::planning() + 11;
    } else {
	plan skip_all => "No UA_Client_disconnectAsync in open62541";
    }
}
use Test::Exception;
use Test::NoWarnings;
use Test::LeakTrace;

my $server = OPCUA::Open62541::Test::Server->new();
$server->start();
my $client = OPCUA::Open62541::Test::Client->new(port => $server->port());
$client->start();
$server->run();
$client->run();

is($client->{client}->disconnectAsync(), STATUSCODE_GOOD, "disconnect async");
$client->iterate(undef, "disconnect");
is($client->{client}->getState(), CLIENTSTATE_DISCONNECTED, "state");

$client = OPCUA::Open62541::Test::Client->new(port => $server->port());
$client->start();
$client->run();

# Run the test again, check for leaks, no check within leak detection.
no_leaks_ok {
    $client->{client}->disconnectAsync();
    $client->iterate(undef);
} "disconnect async leak";
