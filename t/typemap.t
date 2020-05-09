# the typemap must find invalid SV objects passed to the functions

use strict;
use warnings;
use OPCUA::Open62541 qw(:STATUSCODE :TYPES);

use OPCUA::Open62541::Test::Server;
use Test::More tests => OPCUA::Open62541::Test::Server::planning_nofork() + 103;
use Test::Exception;
use Test::LeakTrace;
use Test::NoWarnings;
use Test::Warn;

### create some objects upfront

# server uses variant parameter, output parameter, and optional parameter

my $server = OPCUA::Open62541::Test::Server->new();
$server->start();
my %nodes = $server->setup_complex_objects();
my %nodeid = %{$nodes{some_variable_0}{nodeId}};
my @addargs = (
    $nodes{some_variable_0}{nodeId},
    $nodes{some_variable_0}{parentNodeId},
    $nodes{some_variable_0}{referenceTypeId},
    $nodes{some_variable_0}{browseName},
    $nodes{some_variable_0}{typeDefinition},
    $nodes{some_variable_0}{attributes},
    0
);

# client needed to tests wrong type

ok(my $client = OPCUA::Open62541::Client->new(), "client");
is(ref($client), "OPCUA::Open62541::Client", "client ref");

### variant has simple constructor, so it is easy to test

# variant constructor new

ok(my $variant = OPCUA::Open62541::Variant->new(), "new");
is(ref($variant), "OPCUA::Open62541::Variant", "new ref");
no_leaks_ok { OPCUA::Open62541::Variant->new() } "new leak";

throws_ok { OPCUA::Open62541::Variant::new() }
    (qr/Usage: OPCUA::Open62541::Variant::new\(class\) /,
    "new usage class");
no_leaks_ok { eval { OPCUA::Open62541::Variant::new() } }
    "new usage class leak";

throws_ok { OPCUA::Open62541::Variant->new("") }
    (qr/Usage: OPCUA::Open62541::Variant::new\(class\) /,
    "new usage parameter");
no_leaks_ok { eval { OPCUA::Open62541::Variant->new("") } }
    "new usage parameter leak";

throws_ok {
    no warnings;
    OPCUA::Open62541::Variant::new(undef);
} (qr/new: Class '' is not OPCUA::Open62541::Variant /,
    "new undef");
warning_like { eval { OPCUA::Open62541::Variant::new(undef) } }
    (qr/Use of uninitialized value in subroutine entry at /,
    "new undef warn");
no_leaks_ok { eval {
    no warnings;
    OPCUA::Open62541::Variant::new(undef);
} } "new undef leak";

throws_ok { OPCUA::Open62541::Variant::new("OPCUA::Open62541::Client") }
    (qr/new: Class 'OPCUA::Open62541::Client' is not \w+::Open62541::Variant /,
    "new class type");
no_leaks_ok { eval {
    OPCUA::Open62541::Variant::new("OPCUA::Open62541::Client");
} } "new class type leak";

# variant destructor destroy

# XXX
# cannot call the correct form as it would cause a double free
# it is always called automatically
SKIP: {
    skip "test would crash: explicit destroy causes double free", 2;
lives_ok { OPCUA::Open62541::Variant::DESTROY($variant) }
    "destroy explicit";
no_leaks_ok { OPCUA::Open62541::Variant::DESTROY($variant) }
    "destroy explicit leak";
}

throws_ok { OPCUA::Open62541::Variant::DESTROY() }
    (qr/Usage: OPCUA::Open62541::Variant::DESTROY\(variant\) /,
    "destroy usage class");
no_leaks_ok { eval { OPCUA::Open62541::Variant::DESTROY() } }
    "destroy usage class leak";

throws_ok { OPCUA::Open62541::Variant::DESTROY($variant, "") }
    (qr/Usage: OPCUA::Open62541::Variant::DESTROY\(variant\) /,
    "destroy usage parameter");
no_leaks_ok { eval { OPCUA::Open62541::Variant::DESTROY($variant, "") } }
    "destroy usage parameter leak";

throws_ok { OPCUA::Open62541::Variant::DESTROY($client) }
    (qr/DESTROY: Self variant is not a OPCUA::Open62541::Variant /,
    "destroy self type");
no_leaks_ok { eval {
    OPCUA::Open62541::Variant::DESTROY($client);
} } "destroy self type leak";

# variant method isEmpty()

ok(OPCUA::Open62541::Variant::isEmpty($variant), "isempty");

throws_ok { OPCUA::Open62541::Variant::isEmpty() }
    (qr/Usage: OPCUA::Open62541::Variant::isEmpty\(variant\) /,
    "isempty usage class");
no_leaks_ok { eval { OPCUA::Open62541::Variant::isEmpty() } }
    "isempty usage class leak";

throws_ok { OPCUA::Open62541::Variant::isEmpty($variant, "") }
    (qr/Usage: OPCUA::Open62541::Variant::isEmpty\(variant\) /,
    "isempty usage parameter");
no_leaks_ok { eval { OPCUA::Open62541::Variant::isEmpty($variant, "") } }
    "isempty usage parameter leak";

throws_ok { OPCUA::Open62541::Variant::isEmpty($client) }
    (qr/isEmpty: Self variant is not a OPCUA::Open62541::Variant /,
    "isempty self type");
no_leaks_ok { eval {
    OPCUA::Open62541::Variant::isEmpty($client);
} } "isempty self type leak";

### server uses variant as parameter

my %value = (
    Variant_type	=> TYPES_INT32,
    Variant_scalar	=> 23,
);

my $outvalue;

# server method writeValue with input variant

is($server->{server}->writeValue(\%nodeid, \%value), STATUSCODE_GOOD,
    "write value");
no_leaks_ok { $server->{server}->writeValue(\%nodeid, \%value) }
    "write value leak";

throws_ok { $server->{server}->writeValue(\%nodeid) }
    (qr/Usage: \w+::Open62541::Server::writeValue\(server, nodeId, value\) /,
    "write value usage");
no_leaks_ok { eval { $server->{server}->writeValue(\%nodeid) } }
    "write value usage leak";

# XXX expect a more specific error message
throws_ok { $server->{server}->writeValue(\%nodeid, undef) }
    (qr/Variant: Not a HASH reference /,
    "write value undef");
no_leaks_ok { eval { $server->{server}->writeValue(\%nodeid, undef) } }
    "write value undef leak";

# XXX expect a more specific error message
throws_ok { $server->{server}->writeValue(\%nodeid, 77) }
    (qr/Variant: Not a HASH reference /,
    "write value number");
no_leaks_ok { eval { $server->{server}->writeValue(\%nodeid, 77) } }
    "write value number leak";

# XXX expect a more specific error message
$outvalue = 5;
throws_ok { $server->{server}->writeValue(\%nodeid, $outvalue) }
    (qr/Variant: Not a HASH reference /,
    "write value variable");
$outvalue = 5;
no_leaks_ok { eval { $server->{server}->writeValue(\%nodeid, $outvalue) } }
    "write value variable leak";

# XXX expect a more specific error message
throws_ok { $server->{server}->writeValue(\%nodeid, []) }
    (qr/Variant: Not a HASH reference /,
    "write value array");
no_leaks_ok { eval { $server->{server}->writeValue(\%nodeid, []) } }
    "write value array leak";

throws_ok { $server->{server}->writeValue(\%nodeid, {}) }
    (qr/Variant: No Variant_type in HASH /,
    "write value hash");
no_leaks_ok { eval { $server->{server}->writeValue(\%nodeid, {}) } }
    "write value hash leak";

$outvalue = {};
throws_ok { $server->{server}->writeValue(\%nodeid, \$outvalue) }
    (qr/Variant: Not a HASH reference /,
    "write value hashref");
$outvalue = {};
no_leaks_ok { eval { $server->{server}->writeValue(\%nodeid, \$outvalue) } }
    "write value hashref leak";

# XXX expect a more specific error message
throws_ok { $server->{server}->writeValue(\%nodeid, $client) }
    (qr/Variant: Not a HASH reference /,
    "write client type");
is(ref($client), 'OPCUA::Open62541::Client', "write client ref");
no_leaks_ok { eval { $server->{server}->writeValue(\%nodeid, $client) } }
    "write client type leak";

# XXX expect a more specific error message
throws_ok { $server->{server}->writeValue(\%nodeid, $variant) }
    (qr/Variant: Not a HASH reference /,
    "write variant type");
is(ref($variant), 'OPCUA::Open62541::Variant', "write variant ref");
no_leaks_ok { eval { $server->{server}->writeValue(\%nodeid, $variant) } }
    "write variant type leak";

# server method readValue with output variant

undef $outvalue;
is($server->{server}->readValue(\%nodeid, \$outvalue), STATUSCODE_GOOD,
    "read value");
is(ref($outvalue), 'HASH', "read value ref");
is_deeply($outvalue, \%value, "read value content");
undef $outvalue;
no_leaks_ok { $server->{server}->readValue(\%nodeid, \$outvalue) }
    "read value leak";

throws_ok { $server->{server}->readValue(\%nodeid) }
    (qr/Usage: \w+::Open62541::Server::readValue\(server, nodeId, outValue\) /,
    "read outvalue usage");
no_leaks_ok { eval { $server->{server}->readValue(\%nodeid) } }
    "read outvalue usage leak";

throws_ok { $server->{server}->readValue(\%nodeid, undef) }
    (qr/readValue: Parameter outValue is not a scalar reference /,
    "read outvalue undef");
no_leaks_ok { eval { $server->{server}->readValue(\%nodeid, undef) } }
    "read outvalue undef leak";

throws_ok { $server->{server}->readValue(\%nodeid, 77) }
    (qr/readValue: Parameter outValue is not a scalar reference /,
    "read outvalue number");
no_leaks_ok { eval { $server->{server}->readValue(\%nodeid, 77) } }
    "read outvalue number leak";

$outvalue = 5;
throws_ok { $server->{server}->readValue(\%nodeid, $outvalue) }
    (qr/readValue: Parameter outValue is not a scalar reference /,
    "read outvalue variable");
$outvalue = 5;
no_leaks_ok { eval { $server->{server}->readValue(\%nodeid, $outvalue) } }
    "read outvalue variable leak";

throws_ok { $server->{server}->readValue(\%nodeid, []) }
    (qr/readValue: Parameter outValue is not a scalar reference /,
    "read outvalue array");
no_leaks_ok { eval { $server->{server}->readValue(\%nodeid, []) } }
    "read outvalue array leak";

throws_ok { $server->{server}->readValue(\%nodeid, {}) }
    (qr/readValue: Parameter outValue is not a scalar reference /,
    "read outvalue hash");
no_leaks_ok { eval { $server->{server}->readValue(\%nodeid, {}) } }
    "read outvalue hash leak";

$outvalue = [];
is($server->{server}->readValue(\%nodeid, \$outvalue), STATUSCODE_GOOD,
    "read outvalue arrayref");
$outvalue = [];
no_leaks_ok { $server->{server}->readValue(\%nodeid, \$outvalue) }
    "read outvalue arrayref leak";

$outvalue = {};
is($server->{server}->readValue(\%nodeid, \$outvalue), STATUSCODE_GOOD,
    "read outvalue hashref");
is(ref($outvalue), 'HASH', "read outvalue ref");
$outvalue = {};
no_leaks_ok { $server->{server}->readValue(\%nodeid, \$outvalue) }
    "read outvalue hashref leak";

throws_ok { $server->{server}->readValue(\%nodeid, $client) }
    (qr/readValue: Parameter outValue is not a scalar reference /,
    "read client type");
no_leaks_ok { eval { $server->{server}->readValue(\%nodeid, $client) } }
    "read client type leak";
is(ref($client), 'OPCUA::Open62541::Client', "read client ref");

# XXX
SKIP: {
    skip "test would crash: output variant reference should croak", 3;
is($server->{server}->readValue(\%nodeid, $variant), STATUSCODE_GOOD,
    "read outvalue variant");
is(ref($variant), 'OPCUA::Open62541::Variant', "read variant ref");
no_leaks_ok { $server->{server}->readValue(\%nodeid, $variant) }
    "read outvalue variant leak";
}

### server uses nodeid as optional parameter

# delete node to call add node afterwards

is($server->{server}->deleteNode(\%nodeid, 0), STATUSCODE_GOOD,
    "delete node");
is($server->{server}->addVariableNode(@addargs, undef), STATUSCODE_GOOD,
    "add node");
no_leaks_ok {
    $server->{server}->deleteNode(\%nodeid, 0);
    $server->{server}->addVariableNode(@addargs, undef)
} "add node leak";
is($server->{server}->addVariableNode(@addargs, undef),
    STATUSCODE_BADNODEIDEXISTS,
    "add node exists");

# server method addVariableNode with output nodeid

my $addparams = "server, requestedNewNodeId, parentNodeId, referenceTypeId, ".
    "browseName, typeDefinition, attr, nodeContext, outNewNodeId";

throws_ok { $server->{server}->addVariableNode(@addargs) }
    (qr/Usage: \w+::Open62541::Server::addVariableNode\($addparams\) /,
    "add node usage");
no_leaks_ok { eval { $server->{server}->addVariableNode(@addargs) } }
    "add node usage leak";

throws_ok { $server->{server}->addVariableNode(@addargs, 77) }
    (qr/addVariableNode: Parameter outNewNodeId is not a scalar reference /,
    "add node out number");
no_leaks_ok { eval { $server->{server}->addVariableNode(@addargs, 77) } }
    "add node out number leak";

my $outnodeid = 5;
throws_ok { $server->{server}->addVariableNode(@addargs, $outnodeid) }
    (qr/addVariableNode: Parameter outNewNodeId is not a scalar reference /,
    "add node out variable");
$outnodeid = 5;
no_leaks_ok { eval {
    $server->{server}->addVariableNode(@addargs, $outnodeid)
} } "add node out variable leak";

throws_ok { $server->{server}->addVariableNode(@addargs, []) }
    (qr/addVariableNode: Parameter outNewNodeId is not a scalar reference /,
    "add node out array");
no_leaks_ok { eval {
    $server->{server}->addVariableNode(@addargs, [])
} } "add node out array leak";

throws_ok { $server->{server}->addVariableNode(@addargs, {}) }
    (qr/addVariableNode: Parameter outNewNodeId is not a scalar reference /,
    "add node out hash");
no_leaks_ok { eval {
    $server->{server}->addVariableNode(@addargs, {})
} } "add node out hash leak";

# XXX outNewNodeId should be a HASH ref
$outnodeid = {};
is($server->{server}->deleteNode(\%nodeid, 0), STATUSCODE_GOOD,
    "delete node out hashref");
is($server->{server}->addVariableNode(@addargs, \$outnodeid), STATUSCODE_GOOD,
    "add node out hashref");
is(ref($outnodeid), 'OPCUA::Open62541::NodeId', "read outvalue ref");
$outnodeid = {};
no_leaks_ok {
    $server->{server}->deleteNode(\%nodeid, 0);
    $server->{server}->addVariableNode(@addargs, \$outnodeid);
} "add node out hashref leak";

throws_ok { $server->{server}->addVariableNode(@addargs, $client) }
    (qr/addVariableNode: Parameter outNewNodeId is not a scalar reference /,
    "add node client type");
no_leaks_ok { eval { $server->{server}->addVariableNode(@addargs, $client) } }
    "add node client type leak";
is(ref($client), 'OPCUA::Open62541::Client', "read client ref");
