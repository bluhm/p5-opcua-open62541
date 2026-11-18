use strict;
use warnings;

use OPCUA::Open62541 ':all';
use OPCUA::Open62541::Test::Server;
use OPCUA::Open62541::Test::Client;
use Data::Dumper;

# Plan: server setup + client setup + 6 explicit assertions + 1 Test::NoWarnings = +7
use Test::More tests =>
    OPCUA::Open62541::Test::Server::planning() +
    OPCUA::Open62541::Test::Client::planning() + 9;
use Test::LeakTrace;
use Test::NoWarnings;

# 1. Start test server and client
my $server = OPCUA::Open62541::Test::Server->new();
$server->start();

my $client = OPCUA::Open62541::Test::Client->new(port => $server->port());
$client->start();

# 2. Populate server address space and extract the expected node details
my %nodes         = $server->setup_complex_objects();
my %expected_node = %{$nodes{some_variable_0}};
my %nodeid        = %{$expected_node{nodeId}};
my $nodeid_print  = $nodeid{NodeId_print};

# Run event loops so server and client complete connection handshake
$server->run();
$client->run();

# 3. Testing whether a string can also be parsed to C
my $out_nodeid;
is(
    $client->{client}->readNodeIdAttribute($nodeid_print, \$out_nodeid),
    STATUSCODE_GOOD,
    "client readNodeIdAttribute status"
);

is_deeply(
    $out_nodeid,
    $expected_node{nodeId},
    "client readNodeIdAttribute matches expected nodeId"
);

my $out_browsename;
is(
    $client->{client}->readBrowseNameAttribute(\%nodeid, \$out_browsename),
    STATUSCODE_GOOD,
    "client readBrowseNameAttribute status"
);
is_deeply(
    $out_browsename,
    $expected_node{browseName},
    "client readBrowseNameAttribute matches expected browseName"
);

# 4. Clean up
$client->stop();
$server->stop();
