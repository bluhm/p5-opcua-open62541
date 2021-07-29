use strict;
use warnings;

use OPCUA::Open62541 qw(:all);
use OPCUA::Open62541::Test::Client;
use OPCUA::Open62541::Test::Server;

use Test::More tests =>
    OPCUA::Open62541::Test::Server::planning() +
    OPCUA::Open62541::Test::Client::planning() + 3;
use Test::NoWarnings;

# 1 - working
# 2 - core dump

for (1 .. 2) {
    ok(OPCUA::Open62541::Client->MonitoredItemCreateRequest_default({
	NodeId_namespaceIndex => 1,
	NodeId_identifierType => NODEIDTYPE_STRING,
	NodeId_identifier     => "var1",
    }), "test $_");
}
