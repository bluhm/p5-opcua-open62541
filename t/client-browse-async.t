use strict;
use warnings;
use OPCUA::Open62541 qw(BROWSERESULTMASK_ALL :STATUSCODE);
use OPCUA::Open62541::NS0ID;

use OPCUA::Open62541::Test::Server;
use OPCUA::Open62541::Test::Client;
use Test::More tests =>
    OPCUA::Open62541::Test::Server::planning() +
    OPCUA::Open62541::Test::Client::planning() + 28;
use Test::Deep;
use Test::Exception;
use Test::NoWarnings;
use Test::LeakTrace;

my $server = OPCUA::Open62541::Test::Server->new();
$server->port(4840);
$server->start();
my $client = OPCUA::Open62541::Test::Client->new(port => $server->port());
$client->start();
$server->run();
$client->run();

my $request = {
    BrowseRequest_requestedMaxReferencesPerNode => 0,
    BrowseRequest_nodesToBrowse => [
	{
	    BrowseDescription_nodeId => {
		NodeId_namespaceIndex => 0,
		NodeId_identifierType => 0,
		NodeId_identifier => OPCUA::Open62541::NS0ID::ROOTFOLDER,
	    },
	    BrowseDescription_resultMask => BROWSERESULTMASK_ALL,
	}
    ],
};

my $response = {
  'BrowseResponse_diagnosticInfos' => [],
  'BrowseResponse_results' => [
    {
      'BrowseResult_references' => [
	{
	  'ReferenceDescription_nodeId' => {
	    'ExpandedNodeId_serverIndex' => 0,
	    'ExpandedNodeId_nodeId' => {
	      'NodeId_identifier' => 61,
	      'NodeId_identifierType' => 0,
	      'NodeId_namespaceIndex' => 0
	    },
	    'ExpandedNodeId_namespaceUri' => undef
	  },
	  'ReferenceDescription_isForward' => 1,
	  'ReferenceDescription_displayName' => {
	    'LocalizedText_text' => 'FolderType',
	    'LocalizedText_locale' => ''
	  },
	  'ReferenceDescription_nodeClass' => 8,
	  'ReferenceDescription_referenceTypeId' => {
	    'NodeId_identifier' => 40,
	    'NodeId_identifierType' => 0,
	    'NodeId_namespaceIndex' => 0
	  },
	  'ReferenceDescription_typeDefinition' => {
	    'ExpandedNodeId_nodeId' => {
	      'NodeId_identifierType' => 0,
	      'NodeId_identifier' => 0,
	      'NodeId_namespaceIndex' => 0
	    },
	    'ExpandedNodeId_namespaceUri' => undef,
	    'ExpandedNodeId_serverIndex' => 0
	  },
	  'ReferenceDescription_browseName' => {
	    'name' => 'FolderType',
	    'namespaceIndex' => 0
	  }
	},
	{
	  'ReferenceDescription_referenceTypeId' => {
	    'NodeId_identifier' => 35,
	    'NodeId_identifierType' => 0,
	    'NodeId_namespaceIndex' => 0
	  },
	  'ReferenceDescription_typeDefinition' => {
	    'ExpandedNodeId_serverIndex' => 0,
	    'ExpandedNodeId_namespaceUri' => undef,
	    'ExpandedNodeId_nodeId' => {
	      'NodeId_identifier' => 61,
	      'NodeId_identifierType' => 0,
	      'NodeId_namespaceIndex' => 0
	    }
	  },
	  'ReferenceDescription_browseName' => {
	    'name' => 'Objects',
	    'namespaceIndex' => 0
	  },
	  'ReferenceDescription_nodeId' => {
	    'ExpandedNodeId_serverIndex' => 0,
	    'ExpandedNodeId_nodeId' => {
	      'NodeId_identifier' => 85,
	      'NodeId_identifierType' => 0,
	      'NodeId_namespaceIndex' => 0
	    },
	    'ExpandedNodeId_namespaceUri' => undef
	  },
	  'ReferenceDescription_isForward' => 1,
	  'ReferenceDescription_nodeClass' => 1,
	  'ReferenceDescription_displayName' => {
	    'LocalizedText_locale' => '',
	    'LocalizedText_text' => 'Objects'
	  }
	},
	{
	  'ReferenceDescription_browseName' => {
	    'namespaceIndex' => 0,
	    'name' => 'Types'
	  },
	  'ReferenceDescription_referenceTypeId' => {
	    'NodeId_identifierType' => 0,
	    'NodeId_identifier' => 35,
	    'NodeId_namespaceIndex' => 0
	  },
	  'ReferenceDescription_typeDefinition' => {
	    'ExpandedNodeId_serverIndex' => 0,
	    'ExpandedNodeId_namespaceUri' => undef,
	    'ExpandedNodeId_nodeId' => {
	      'NodeId_identifier' => 61,
	      'NodeId_identifierType' => 0,
	      'NodeId_namespaceIndex' => 0
	    }
	  },
	  'ReferenceDescription_isForward' => 1,
	  'ReferenceDescription_displayName' => {
	    'LocalizedText_text' => 'Types',
	    'LocalizedText_locale' => ''
	  },
	  'ReferenceDescription_nodeClass' => 1,
	  'ReferenceDescription_nodeId' => {
	    'ExpandedNodeId_serverIndex' => 0,
	    'ExpandedNodeId_namespaceUri' => undef,
	    'ExpandedNodeId_nodeId' => {
	      'NodeId_identifier' => 86,
	      'NodeId_identifierType' => 0,
	      'NodeId_namespaceIndex' => 0
	    }
	  }
	},
	{
	  'ReferenceDescription_nodeId' => {
	    'ExpandedNodeId_nodeId' => {
	      'NodeId_namespaceIndex' => 0,
	      'NodeId_identifier' => 87,
	      'NodeId_identifierType' => 0
	    },
	    'ExpandedNodeId_namespaceUri' => undef,
	    'ExpandedNodeId_serverIndex' => 0
	  },
	  'ReferenceDescription_nodeClass' => 1,
	  'ReferenceDescription_displayName' => {
	    'LocalizedText_text' => 'Views',
	    'LocalizedText_locale' => ''
	  },
	  'ReferenceDescription_isForward' => 1,
	  'ReferenceDescription_typeDefinition' => {
	    'ExpandedNodeId_namespaceUri' => undef,
	    'ExpandedNodeId_nodeId' => {
	      'NodeId_identifier' => 61,
	      'NodeId_identifierType' => 0,
	      'NodeId_namespaceIndex' => 0
	    },
	    'ExpandedNodeId_serverIndex' => 0
	  },
	  'ReferenceDescription_referenceTypeId' => {
	    'NodeId_namespaceIndex' => 0,
	    'NodeId_identifierType' => 0,
	    'NodeId_identifier' => 35
	  },
	  'ReferenceDescription_browseName' => {
	    'name' => 'Views',
	    'namespaceIndex' => 0
	  }
	}
      ],
      'BrowseResult_continuationPoint' => undef,
      'BrowseResult_statusCode' => 'Good'
    }
  ],
  'BrowseResponse_responseHeader' => {
    'ResponseHeader_stringTable' => [],
    'ResponseHeader_timestamp' => re(qr/^\d+$/),  # '132282586240806600',
    'ResponseHeader_requestHandle' => re(qr/^\d+$/),  # 5,
    'ResponseHeader_serviceDiagnostics' => {
      'DiagnosticInfo_hasSymbolicId' => '',
      'DiagnosticInfo_locale' => 0,
      'DiagnosticInfo_localizedText' => 0,
      'DiagnosticInfo_additionalInfo' => undef,
      'DiagnosticInfo_hasInnerStatusCode' => '',
      'DiagnosticInfo_namespaceUri' => 0,
      'DiagnosticInfo_hasAdditionalInfo' => '',
      'DiagnosticInfo_hasNamespaceUri' => '',
      'DiagnosticInfo_hasLocalizedText' => '',
      'DiagnosticInfo_hasLocale' => '',
      'DiagnosticInfo_innerStatusCode' => 'Good',
      'DiagnosticInfo_hasInnerDiagnosticInfo' => '',
      'DiagnosticInfo_symbolicId' => 0
    },
    'ResponseHeader_serviceResult' => 'Good',
    'ResponseHeader_additionalHeader' => {
      'ExtensionObject_content_typeId' => {
	'NodeId_identifier' => 0,
	'NodeId_identifierType' => 0,
	'NodeId_namespaceIndex' => 0
      },
      'ExtensionObject_content_body' => undef,
      'ExtensionObject_encoding' => 0
    }
  }
};

### deep

my $data = "foo",
my $reqid;
my $browsed = 0;
is($client->{client}->sendAsyncBrowseRequest(
    $request,
    sub {
	my ($c, $d, $i, $r) = @_;

	is($c, $client->{client}, "client");
	is($$d, "foo", "data in");
	$$d = "bar";
	is($i, $reqid, "reqid");
	cmp_deeply($r, $response, "response");

	$browsed = 1;
    },
    \$data,
    \$reqid,
), STATUSCODE_GOOD, "sendAsyncBrowseRequest");
is($data, "foo", "data unchanged");
like($reqid, qr/^\d+$/, "reqid number");
$client->iterate(\$browsed, "browse deep");
is($data, 'bar', "data out");

no_leaks_ok {
    $browsed = 0;
    $client->{client}->sendAsyncBrowseRequest(
	$request,
	sub {
	    my ($c, $d, $i, $r) = @_;
	    $browsed = 1;
	},
	$data,
	\$reqid,
    );
    $client->iterate(\$browsed);
} "sendAsyncBrowseRequest leak";

### data reqid undef

$browsed = 0;
is($client->{client}->sendAsyncBrowseRequest(
    $request,
    sub {
	my ($c, $d, $i, $r) = @_;

	is($d, undef, "data undef");
	like($reqid, qr/^\d+$/, "reqid number");

	$browsed = 1;
    },
    undef,
    undef,
), STATUSCODE_GOOD, "sendAsyncBrowseRequest undef");
$client->iterate(\$browsed, "browse undef");

no_leaks_ok {
    $browsed = 0;
    $client->{client}->sendAsyncBrowseRequest(
	$request,
	sub {
	    my ($c, $d, $i, $r) = @_;
	    $browsed = 1;
	},
	undef,
	undef,
    );
    $client->iterate(\$browsed);
} "sendAsyncBrowseRequest undef leak";

### reqid bad ref

throws_ok {
    $client->{client}->sendAsyncBrowseRequest(
	$request,
	sub {
	    my ($c, $d, $i, $r) = @_;
	},
	undef,
	[],
    );
} (qr/reqId is not a scalar reference /, "sendAsyncBrowseRequest ref reqid");

no_leaks_ok { eval {
    $client->{client}->sendAsyncBrowseRequest(
	$request,
	sub {
	    my ($c, $d, $i, $r) = @_;
	},
	undef,
	[],
    );
} } "sendAsyncBrowseRequest ref reqid leak";

### client undef

throws_ok {
    OPCUA::Open62541::Client::sendAsyncBrowseRequest(
	undef,
	$request,
	sub {
	    my ($c, $d, $i, $r) = @_;
	},
	undef,
	undef,
    );
} (qr/client is not of type OPCUA::Open62541::Client /,
    "sendAsyncBrowseRequest undef client");

no_leaks_ok { eval {
    OPCUA::Open62541::Client::sendAsyncBrowseRequest(
	undef,
	$request,
	sub {
	    my ($c, $d, $i, $r) = @_;
	},
	undef,
	undef,
    );
} } "sendAsyncBrowseRequest undef client leak";

### request undef

throws_ok {
    $client->{client}->sendAsyncBrowseRequest(
	undef,
	sub {
	    my ($c, $d, $i, $r) = @_;
	},
	undef,
	undef,
    );
} (qr/XS_unpack_UA_BrowseRequest: Not a HASH reference /,
    "sendAsyncBrowseRequest undef request");

no_leaks_ok { eval {
    $client->{client}->sendAsyncBrowseRequest(
	undef,
	sub {
	    my ($c, $d, $i, $r) = @_;
	},
	undef,
	undef,
    );
} } "sendAsyncBrowseRequest undef request leak";

### callback undef

throws_ok {
    $client->{client}->sendAsyncBrowseRequest(
	$request,
	"foobar",
	undef,
	undef,
    );
} (qr/Callback 'foobar' is not a CODE reference /,
    "sendAsyncBrowseRequest bad callback");

no_leaks_ok { eval {
    $client->{client}->sendAsyncBrowseRequest(
	$request,
	"foobar",
	undef,
	undef,
    );
} } "sendAsyncBrowseRequest bad callback leak";

$client->stop();

### status fail

# browse with closed client fails, check that it does not leak
$data = "foo";
undef $reqid;
is($client->{client}->sendAsyncBrowseRequest(
    $request,
    sub {
	my ($c, $d, $i, $r) = @_;
	fail "callback called";
    },
    \$data,
    \$reqid,
), STATUSCODE_BADSERVERNOTCONNECTED, "sendAsyncBrowseRequest fail");
is($data, "foo", "data fail");
is($reqid, 0, "reqid zero");

no_leaks_ok {
    $client->{client}->sendAsyncBrowseRequest(
	$request,
	sub {
	    my ($c, $d, $i, $r) = @_;
	},
	\$data,
	\$reqid,
    );
} "sendAsyncBrowseRequest fail leak";

$server->stop();
