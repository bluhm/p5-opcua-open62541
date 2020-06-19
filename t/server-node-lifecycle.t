use strict;
use warnings;
use OPCUA::Open62541 qw(:all);

use OPCUA::Open62541::Test::Server;
use Test::More;
BEGIN {
    if (OPCUA::Open62541::Server->can('setAdminSessionContext')) {
	plan tests => OPCUA::Open62541::Test::Server::planning_nofork() + 68;
    } else {
	plan skip_all => "No UA_Server_setAdminSessionContext in open62541";
    }
}
use Test::Exception;
use Test::LeakTrace;
use Test::NoWarnings;
use Test::Warn;

my $server = OPCUA::Open62541::Test::Server->new();
$server->start();
my %nodes = $server->setup_complex_objects();

sub addNodeStatus {
    return $server->{server}->addVariableNode(
	$nodes{some_variable_0}{nodeId},
	$nodes{some_variable_0}{parentNodeId},
	$nodes{some_variable_0}{referenceTypeId},
	$nodes{some_variable_0}{browseName},
	$nodes{some_variable_0}{typeDefinition},
	$nodes{some_variable_0}{attributes},
	$_[0], $_[1]);
}

sub addNodeGood {
    is(addNodeStatus(@_), STATUSCODE_GOOD, "add node");
}

sub deleteNodeStatus {
    return $server->{server}->deleteNode($nodes{some_variable_0}{nodeId}, 1);
}

sub deleteNodeGood {
    is(deleteNodeStatus(), STATUSCODE_GOOD, "delete node");
}

lives_ok {
    $server->{config}->setGlobalNodeLifecycle({
	GlobalNodeLifecycle_constructor =>
	    sub { note "constructor", explain [ @_ ]; STATUSCODE_GOOD },
	GlobalNodeLifecycle_destructor =>
	    sub { note "destructor", explain [ @_ ] },
	GlobalNodeLifecycle_createOptionalChild =>
	    sub { note "createOptionalChild", explain [ @_ ] },
	GlobalNodeLifecycle_generateChildNodeId =>
	    sub { note "generateChildNodeId", explain [ @_ ] },
    });
} "set global node livecycle";

deleteNodeGood();
addNodeGood();
deleteNodeGood();

# session context

my %admin_session_guid = (
    NodeId_namespaceIndex	=> 0,
    NodeId_identifierType	=> 4,
    NodeId_identifier		=> "00000001-0000-0000-0000-000000000000",
);

$server->{config}->setGlobalNodeLifecycle({
    GlobalNodeLifecycle_constructor => sub {
	my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	is($srv, undef, "constructor server");
	is_deeply($sid, \%admin_session_guid, "constructor session id");
	is($sctx, undef, "constructor session context");
	is_deeply($nid, $nodes{some_variable_0}{nodeId}, "constructor node id");
	is($$nctx, undef, "constructor node context");
	return STATUSCODE_GOOD;
    }
});
addNodeGood();
deleteNodeGood();

my $data = "foo";
lives_ok {
    $server->{server}->setAdminSessionContext(\$data);
} "set admin sessio context";

$server->{config}->setGlobalNodeLifecycle({
    GlobalNodeLifecycle_constructor => sub {
	my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	is($srv, $server->{server}, "constructor server scalar");
	is($$sctx, "foo", "constructor session context in");
	$$sctx = "bar";
	return STATUSCODE_GOOD;
    }
});
addNodeGood();
is($data, "bar", "constructor session context out");
deleteNodeGood();

no_leaks_ok {
    $server->{server}->setAdminSessionContext("foobar");
    $server->{config}->setGlobalNodeLifecycle({
	GlobalNodeLifecycle_constructor => sub {
	    my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	    return STATUSCODE_GOOD;
	}
    });
    addNodeStatus();
    deleteNodeStatus();
} "constructor leak";

# constructor

$data = "foo";
{
    my $callback = sub {
	my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	is($$sctx, "foo", "constructor livetime in");
	$$sctx = "bar";
	return STATUSCODE_GOOD;
    };
    $server->{config}->setGlobalNodeLifecycle({
	GlobalNodeLifecycle_constructor => $callback,
    });
    undef $callback;
    $server->{server}->setAdminSessionContext(\$data);
}
addNodeGood();
is($data, "bar", "constructor livetime out");
deleteNodeGood();

$server->{config}->setGlobalNodeLifecycle({
    GlobalNodeLifecycle_constructor => sub {
	return;
    }
});
warning_like {
    is(addNodeStatus(), STATUSCODE_GOOD, "add return empty");
} (qr/Use of uninitialized value in subroutine entry /,
    "add return empty warn");
deleteNodeGood();

$server->{config}->setGlobalNodeLifecycle({
    GlobalNodeLifecycle_constructor => sub {
	return undef;
    }
});
warning_like {
    is(addNodeStatus(), STATUSCODE_GOOD, "add return undef");
} (qr/Use of uninitialized value in subroutine entry /,
    "add return empty undef");
deleteNodeGood();

$server->{config}->setGlobalNodeLifecycle({
    GlobalNodeLifecycle_constructor => sub {
	return 0xffffffff;
    }
});
is(addNodeStatus(), 0xffffffff, "add return unknown");
# node has not been added, so delete node fails
is(deleteNodeStatus(), STATUSCODE_BADNODEIDUNKNOWN, "delete return unknown");

$server->{config}->setGlobalNodeLifecycle({
    GlobalNodeLifecycle_constructor => sub {
	return 0xffffffff, STATUSCODE_GOOD;
    }
});
addNodeGood();
deleteNodeGood();

# destructor

$data = "foo";
$server->{config}->setGlobalNodeLifecycle({
    GlobalNodeLifecycle_destructor => sub {
	my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	is($srv, $server->{server}, "destructor server scalar");
	is($$sctx, "foo", "destructor session context in");
	$$sctx = "bar";
    }
});
addNodeGood();
is($data, "foo", "destructor session context add");
deleteNodeGood();
is($data, "bar", "destructor session context out");

no_leaks_ok {
    $server->{config}->setGlobalNodeLifecycle({
	GlobalNodeLifecycle_destructor => sub {
	    my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	}
    });
    addNodeStatus();
    deleteNodeStatus();
} "destructor leak";

$data = "foo";
$server->{config}->setGlobalNodeLifecycle({
    GlobalNodeLifecycle_constructor => sub {
	my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	return 0xffffffff;
    },
    GlobalNodeLifecycle_destructor => sub {
	my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	$$sctx = "bar";
    },
});
is(addNodeStatus(), 0xffffffff, "constructor fail");
is($data, "bar", "destructor called");

no_leaks_ok {
    $server->{config}->setGlobalNodeLifecycle({
	GlobalNodeLifecycle_constructor => sub {
	    my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	    return 0xffffffff;
	},
	GlobalNodeLifecycle_destructor => sub {
	    my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	},
    });
    addNodeStatus();
} "destructor called leak";

# set node context in add noce

my $context = "hello";
$server->{config}->setGlobalNodeLifecycle({
    GlobalNodeLifecycle_constructor => sub {
	my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	is($$$nctx, "hello", "constructor node context in");
	$$$nctx = "world";
	return STATUSCODE_GOOD;
    },
    GlobalNodeLifecycle_destructor => sub {
	my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	is($$nctx, "world", "destructor node context in");
	$$nctx = "bye";
    },
});
addNodeGood(\$context);
is($context, "world", "constructor node context out");
deleteNodeGood();
is($context, "bye", "destructor node context out");

no_leaks_ok {
    $context = "hello";
    $server->{config}->setGlobalNodeLifecycle({
	GlobalNodeLifecycle_constructor => sub {
	    my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	    $$$nctx = "world";
	    return STATUSCODE_GOOD;
	},
	GlobalNodeLifecycle_destructor => sub {
	    my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	    $$nctx = "bye";
	},
    });
    addNodeStatus(\$context);
    deleteNodeStatus();
} "node context leak";

# set node context in constructor

$server->{config}->setGlobalNodeLifecycle({
    GlobalNodeLifecycle_constructor => sub {
	my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	is($$nctx, undef, "constructor node context empty");
	$$nctx = "constructed";
	return STATUSCODE_GOOD;
    },
    GlobalNodeLifecycle_destructor => sub {
	my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	is($nctx, "constructed", "destructor node context constructed");
    },
});
addNodeGood();
deleteNodeGood();

no_leaks_ok {
    $server->{config}->setGlobalNodeLifecycle({
	GlobalNodeLifecycle_constructor => sub {
	    my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	    $$nctx = "constructed";
	    return STATUSCODE_GOOD;
	},
	GlobalNodeLifecycle_destructor => sub {
	    my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	},
    });
    addNodeStatus();
    deleteNodeStatus();
} "node context constructed leak";

# context can only be changed by reference, except constructor

$data = "foo";
$server->{server}->setAdminSessionContext($data);
$context = "hello";
$server->{config}->setGlobalNodeLifecycle({
    GlobalNodeLifecycle_constructor => sub {
	my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	is($sctx, "foo", "constructor session context nochange in");
	$sctx = "bar";
	is($$nctx, "hello", "constructor node context nochange in");
	$$nctx = "world";
	return STATUSCODE_GOOD;
    },
    GlobalNodeLifecycle_destructor => sub {
	my ($srv, $sid, $sctx, $nid, $nctx) = @_;
	is($sctx, "foo", "destructor session context nochange in");
	$sctx = "bar";
	is($nctx, "world", "destructor node context nochange in");
	$nctx = "bye";
    },
});
addNodeGood($context);
is($data, "foo", "constructor session context nochange out");
is($context, "hello", "constructor node context nochange out");
deleteNodeGood();
is($data, "foo", "destructor session context nochange out");
is($context, "hello", "destructor node context nochange out");
