use strict;
use warnings;
use OPCUA::Open62541 ':all';

use Test::More tests => 9;
use Test::NoWarnings;

ok(my $server = OPCUA::Open62541::Server->new(), "server");
ok(my $config = $server->getConfig(), "config");
is($config->setDefault(), STATUSCODE_GOOD, "default");
is($server->run_startup(), STATUSCODE_GOOD, "startup");
cmp_ok($server->run_iterate(0), '>', 0, "iterate");

my %requestedNewNodeId = (
    NodeId_namespaceIndex	=> 1,
    NodeId_identifierType	=> NODEIDTYPE_STRING,
    NodeId_identifier		=> "the.answer",
);
my %parentNodeId = (
    NodeId_namespaceIndex	=> 0,
    NodeId_identifierType	=> NODEIDTYPE_NUMERIC,
    NodeId_identifier		=> 85, # UA_NS0ID_OBJECTSFOLDER
);
my %referenceTypeId = (
    NodeId_namespaceIndex	=> 0,
    NodeId_identifierType	=> NODEIDTYPE_NUMERIC,
    NodeId_identifier		=> 35, # UA_NS0ID_ORGANIZES
);
my %browseName = (
    QualifiedName_namespaceIndex	=> 1,
    QualifiedName_name			=> "the answer",
);
my %typeDefinition = (
    NodeId_namespaceIndex	=> 0,
    NodeId_identifierType	=> NODEIDTYPE_NUMERIC,
    NodeId_identifier		=> 63, # UA_NS0ID_BASEDATAVARIABLETYPE
);
ok(my $variant = OPCUA::Open62541::Variant->new(), "variant new");
$variant->setScalar(42, TYPES_INT32);
my %attr = (
    VariableAttributes_displayName	=> "the answer",
    VariableAttributes_description	=> "the answer",
    VariableAttributes_value		=> $variant,
    VariableAttributes_dataType		=> TYPES_INT32,
    VariableAttributes_accessLevel	=>
	ACCESSLEVELMASK_READ | ACCESSLEVELMASK_WRITE,
);

# XXX should be optional, but addVariableNode does not work without it yet.
my %outNewNodeId = (
    NodeId_namespaceIndex	=> 0,
    NodeId_identifierType	=> NODEIDTYPE_NUMERIC,
    NodeId_identifier		=> 0,
);

$server->addVariableNode(\%requestedNewNodeId, \%parentNodeId,
    \%referenceTypeId, \%browseName, \%typeDefinition, \%attr, 0,
    \%outNewNodeId);

cmp_ok($server->run_iterate(0), '>', 0, "iterate");
is($server->run_shutdown(), STATUSCODE_GOOD, "shutdown");
