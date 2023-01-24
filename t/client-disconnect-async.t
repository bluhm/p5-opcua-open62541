use strict;
use warnings;
use OPCUA::Open62541 qw(:STATUSCODE :SESSIONSTATE :SECURECHANNELSTATE);
use Scalar::Util qw(looks_like_number);

use OPCUA::Open62541::Test::Server;
use OPCUA::Open62541::Test::Client;
use Test::More tests =>
    OPCUA::Open62541::Test::Server::planning() +
    OPCUA::Open62541::Test::Client::planning() * 2 + 4;
use Test::Exception;
use Test::NoWarnings;
use Test::LeakTrace;

my $server = OPCUA::Open62541::Test::Server->new();
$server->start();
my $client = OPCUA::Open62541::Test::Client->new(port => $server->port());
$client->start();
$server->run();
$client->run();

# There is a bug in open62541 1.0.6 that crashes the client with a
# segmentation fault.  It happens during connect after disconnect
# as the async service callback sets securityPolicy to NULL.

my $skip_reconnect;
ok(my $buildinfo = $server->{config}->getBuildInfo());
note explain $buildinfo;
if ($buildinfo->{BuildInfo_softwareVersion} =~ /^1\.0\./) {
    $skip_reconnect = "reconnect bug in ".
	"library '$buildinfo->{BuildInfo_manufacturerName}' ".
	"version '$buildinfo->{BuildInfo_softwareVersion}' ".
	"operating system '$^O'";
}

is($client->{client}->disconnectAsync(), STATUSCODE_GOOD, "disconnect async");

$client->iterate_disconnect("disconnect");
is_deeply([$client->{client}->getState()],
    [SECURECHANNELSTATE_CLOSED, SESSIONSTATE_CLOSED, STATUSCODE_GOOD],
    "state");

# try to connect again after disconnect
SKIP: {
    skip $skip_reconnect, 2 if $skip_reconnect;

    $client->{config}->setStateCallback(undef);
    is($client->{client}->connectAsync($client->url()), STATUSCODE_GOOD,
	"connect async again");
    $client->iterate_connect("connect again");
}  # SKIP

$client = OPCUA::Open62541::Test::Client->new(port => $server->port());
$client->start();
$client->run();

# Run the test again, check for leaks, no check within leak detection.
no_leaks_ok {
    $client->{client}->disconnectAsync();
    $client->iterate_disconnect();
} "disconnect async leak";

$server->stop();
