use strict;
use warnings;
use OPCUA::Open62541 qw(:all);

use OPCUA::Open62541::Test::Server;
use Test::More;
BEGIN {
    if (OPCUA::Open62541::Server->can('setAdminSessionContext')) {
	plan tests => OPCUA::Open62541::Test::Server::planning_nofork() + 26;
    } else {
	plan skip_all => "No UA_Server_setAdminSessionContext in open62541";
    }
}
use Test::Exception;
use Test::LeakTrace;
use Test::NoWarnings;

my $server = OPCUA::Open62541::Test::Server->new();
$server->start();
my %nodes = $server->setup_complex_objects();

sub addNodeNotest {
    return $server->{server}->addVariableNode(
	$nodes{some_variable_0}{nodeId},
	$nodes{some_variable_0}{parentNodeId},
	$nodes{some_variable_0}{referenceTypeId},
	$nodes{some_variable_0}{browseName},
	$nodes{some_variable_0}{typeDefinition},
	$nodes{some_variable_0}{attributes},
	0, undef);
}

sub addNode {
    is(addNodeNotest(), STATUSCODE_GOOD, "add node");
}

sub deleteNodeNotest {
    return $server->{server}->deleteNode($nodes{some_variable_0}{nodeId}, 1);
}

sub deleteNode {
    is(deleteNodeNotest(), STATUSCODE_GOOD, "delete node");
}

lives_ok {
    $server->{config}->setGlobalNodeLifecycle({
	GlobalNodeLifecycle_constructor =>
	    sub { note "constructor", explain [ @_ ] },
	GlobalNodeLifecycle_destructor =>
	    sub { note "destructor", explain [ @_ ] },
	GlobalNodeLifecycle_createOptionalChild =>
	    sub { note "createOptionalChild", explain [ @_ ] },
	GlobalNodeLifecycle_generateChildNodeId =>
	    sub { note "generateChildNodeId", explain [ @_ ] },
    });
} "set global node livecycle";

deleteNode();
addNode();
deleteNode();

my %admin_session_guid = (
    NodeId_namespaceIndex	=> 0,
    NodeId_identifierType	=> 4,
    NodeId_identifier		=> "00000001-0000-0000-0000-000000000000",
);

$server->{config}->setGlobalNodeLifecycle({
    GlobalNodeLifecycle_constructor => sub {
	my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	is($srv, undef, "callback server");
	is_deeply($sid, \%admin_session_guid, "callback session id");
	is($sctx, undef, "callback session context");
	is_deeply($nid, $nodes{some_variable_0}{nodeId}, "callback node id");
	like($nctx, qr/^\d+$/, "callback node context");
    }
});
addNode();
deleteNode();

my $data = "foo";
lives_ok {
    $server->{server}->setAdminSessionContext(\$data);
} "set admin sessio context";

$server->{config}->setGlobalNodeLifecycle({
    GlobalNodeLifecycle_constructor => sub {
	my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	is($srv, $server->{server}, "callback server scalar");
	is($$sctx, "foo", "callback session context in");
	$$sctx = "bar";
    }
});
addNode();
is($data, "bar", "callback session context out");
deleteNode();

no_leaks_ok {
    $server->{server}->setAdminSessionContext("foobar");
    $server->{config}->setGlobalNodeLifecycle({
	GlobalNodeLifecycle_constructor => sub {
	    my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	}
    });
    addNodeNotest();
    deleteNodeNotest();
} "callback leak";

$data = "foo";
{
    my $callback = sub {
	my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	is($$sctx, "foo", "callback livetime in");
	$$sctx = "bar";
    };
    $server->{config}->setGlobalNodeLifecycle({
	GlobalNodeLifecycle_constructor => $callback,
    });
    undef $callback;
    $server->{server}->setAdminSessionContext(\$data);
}
addNode();
is($data, "bar", "callback livetime out");
deleteNode();
