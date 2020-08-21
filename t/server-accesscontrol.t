use strict;
use warnings;

use OPCUA::Open62541 qw(:all);
use OPCUA::Open62541::Test::Client;
use OPCUA::Open62541::Test::Server;

use Test::More tests =>
    OPCUA::Open62541::Test::Server::planning() +
    OPCUA::Open62541::Test::Client::planning() + 9;
use Test::Exception;
use Test::NoWarnings;

my $server = OPCUA::Open62541::Test::Server->new();
my $config = $server->{server}->getConfig();
my $status = $config->setDefault();
is($status, STATUSCODE_GOOD, "config defautl status");
$server->start();
$config->setUserAccessLevel_readonly(1);
$server->setup_complex_objects();
$server->run();

my $client = OPCUA::Open62541::Test::Client->new(port => $server->port());
$client->start();
$client->run();

$status = $client->{client}->writeValueAttribute(
    {
	NodeId_namespaceIndex	=> 1,
	NodeId_identifierType	=> NODEIDTYPE_STRING,
	NodeId_identifier	=> "SOME_VARIABLE_0",
    },
    {
	Variant_type => TYPES_INT32,
	Variant_scalar => 23,
    },

);

is($status, STATUSCODE_BADUSERACCESSDENIED, "write status");

my $out;
$status = $client->{client}->readValueAttribute(
    {
	NodeId_namespaceIndex	=> 1,
	NodeId_identifierType	=> NODEIDTYPE_STRING,
	NodeId_identifier	=> "SOME_VARIABLE_0",
    },
    \$out,

);

is($status, STATUSCODE_GOOD, "read status");
is($out->{Variant_scalar}, 42, "read value");

$client->stop();
$server->stop();
