use strict;
use warnings;
use OPCUA::Open62541 qw(:STATUSCODE :CLIENTSTATE);
use IO::Socket::INET;
use Time::HiRes qw(sleep);

use OPCUA::Open62541::Test::Server;
use OPCUA::Open62541::Test::Client;
use Test::More;
BEGIN {
    if (OPCUA::Open62541::Client->can('connectAsync')) {
	plan tests =>
	    OPCUA::Open62541::Test::Server::planning() +
	    OPCUA::Open62541::Test::Client::planning() * 2 + 10;
    } else {
	plan skip_all => "No UA_Client_connectAsync in open62541";
    }
}
use Test::Exception;
#use Test::NoWarnings;
use Test::LeakTrace;

my $server = OPCUA::Open62541::Test::Server->new();
$server->start();

my $client = OPCUA::Open62541::Test::Client->new(port => $server->port());
$client->start();
$server->run();

my $data = ['foo'];
$client->{config}->setClientContext($data);
    $client->{client}->getConfig();
my $connected = 0;
sub callback {
    my ($c, $channel, $session, $connect) = @_;
    return unless $channel == 6 && $session == 4;
    $connected = 1;
}
#$client->{config}->setStateCallback(\&callback);

is($client->{client}->connectAsync($client->url()), STATUSCODE_GOOD,
    "connect async");
# wait an initial 100ms for open62541 to start the timer that creates the socket
sleep .1;
$client->iterate(\$connected, "connect");

$client->stop();

$client = OPCUA::Open62541::Test::Client->new(port => $server->port());
$client->start();

# Run the test again, check for leaks, no check within leak detection.
#no_leaks_ok {
#    $client->{client}->connectAsync($client->url());
#    sleep .1;
#    $client->iterate(\$connected);
#} "connect async leak";

$client->stop();

$server->stop();

# Run test without callback being called due to nonexisting target.
# The connectAsync() call must succeed, but iterate() must fail.
# A non OPC UA server accepting TCP will do the job.

my $tcp_server = IO::Socket::INET->new(
    LocalAddr	=> "localhost",
    Proto	=> "tcp",
    Listen	=> 1,
);
ok($tcp_server, "tcp server") or diag "tcp server new and listen failed: $!";
my $tcp_port = $tcp_server->sockport();

$client = OPCUA::Open62541::Test::Client->new(port => $tcp_port);
$client->start();

is($client->{client}->connectAsync($client->url()), STATUSCODE_GOOD,
    "connect async bad url");
undef $tcp_server;
sleep .1;
$client->iterate(undef, "connect bad url");
is($client->{client}->getState(), CLIENTSTATE_DISCONNECTED,
    "client bad connection");

no_leaks_ok {
    $tcp_server = IO::Socket::INET->new(
	LocalAddr	=> "localhost",
	LocalPort	=> $tcp_port,
	Proto		=> "tcp",
	Listen		=> 1,
    );
    $client->{client}->connectAsync($client->url());
    undef $tcp_server;
    sleep .1;
    $client->iterate(undef);
} "connect async bad url leak";


# connect to invalid url fails, check that it does not leak
is($client->{client}->connectAsync("opc.tcp://localhost:"),
    STATUSCODE_BADCONNECTIONCLOSED, "connect async fail");
no_leaks_ok {
    $client->{client}->connectAsync("opc.tcp://localhost:");
} "connect async fail leak";
