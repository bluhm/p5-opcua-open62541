use strict;
use warnings;
use OPCUA::Open62541 ':all';
use POSIX qw(sigaction SIGALRM);

use Net::EmptyPort qw(empty_port);
use Scalar::Util qw(looks_like_number);
use Test::More tests => 21;
use Test::LeakTrace;

# initialize the server

my $s = OPCUA::Open62541::Server->new();
ok($s, "server");

my $sc = $s->getConfig();
ok($s, "config server");

my $port = empty_port();
my $r = $sc->setMinimal($port, "");
is($r, STATUSCODE_GOOD, "minimal server config");

my $pid = fork // die "Unable to fork: $!\n";

if ( !$pid ) {
    my $running = 1;
    sub handler {
	$running = 0;
    }

    # Perl signal handler only works between perl statements.
    # Use the real signal handler to interrupt the OPC UA server.
    # This is not signal safe, best effort is good enough for a test.
    my $sigact = POSIX::SigAction->new(\&handler)
	or die "could not create POSIX::SigAction";
    sigaction(SIGALRM, $sigact)
	or die "sigaction failed: $!";
    alarm(1)
	// die "alarm failed: $!";

    # run server and stop after one second
    $s->run($running);

    POSIX::_exit 0;
}

my @testdesc = (
    ['client', 'client creation'],
    ['config', 'config creation'],
    ['config_default', 'set default config'],
    ['connect_async', 'call to connect_async'],
    ['iterate', 'calls to run_iterate'],
    ['state_session', 'client state SESSION after connect'],
    ['iterate', 'calls to second run_iterate'],
    ['browse_code', 'statuscode of browseresult'],
    ['browse_result_count', 'number of results'],
    ['browse_refs_count', 'number of references'],
    ['browse_refs_foldertype', 'foldertype reference'],
    ['browse_refs_objects', 'objects reference'],
    ['browse_refs_types', 'types reference'],
    ['browse_refs_views', 'views reference'],
    ['disconnect', 'client disconnected'],
    ['state_disconnected', 'client state DISCONNECTED after disconnect'],
);
my %testok = map { $_ => 0 } map { $_->[0] } @testdesc;

no_leaks_ok {
    my $c;
    my $data = ['foo'];
    {
	$c = OPCUA::Open62541::Client->new();
	$testok{client} = 1 if $c;

	my $cc = $c->getConfig();
	$testok{config} = 1 if $cc;

	$r = $cc->setDefault();
	$testok{config_default} = 1 if $r == STATUSCODE_GOOD;

	$r = $c->connect_async("opc.tcp://localhost:$port", undef, undef);
	$testok{connect_async} = 1 if $r == STATUSCODE_GOOD;

	my $maxloop = 1000;
	my $failed_iterate = 0;
	while($c->getState != CLIENTSTATE_SESSION && $maxloop-- > 0) {
	    $r = $c->run_iterate(0);
	    $failed_iterate = 1 if $r != STATUSCODE_GOOD;
	}
	$testok{iterate} = 1 if not $failed_iterate and $maxloop > 0;

	$testok{state_session} = 1 if $c->getState == CLIENTSTATE_SESSION;

	my $browsed = 0;
	$c->sendAsyncBrowseRequest(
	    {
		BrowseRequest_requestedMaxReferencesPerNode => 0,
		BrowseRequest_nodesToBrowse => [
		    {
			BrowseDescription_nodeId => {
			    NodeId_namespaceIndex => 0,
			    NodeId_identifierType => 0,
			    NodeId_identifier => 84,		# UA_NS0ID_ROOTFOLDER
			},
			BrowseDescription_resultMask => 63,	# UA_BROWSERESULTMASK_ALL
		    }
		],
	    },
	    sub {
		my ($c, $d, $i, $r) = @_;
		$browsed = 1;
		push(@$data, $r);
	    },
	    "asdf",
	    4
	);

	$maxloop = 1000;
	$failed_iterate = 0;
	while(not $browsed && $maxloop-- > 0) {
	    $r = $c->run_iterate(0);
	    $failed_iterate = 1 if $r != STATUSCODE_GOOD;
	}
	$testok{iterate2} = 1 if not $failed_iterate and $maxloop > 0;

	my $result_code = $data->[1]{BrowseResponse_responseHeader}{ResponseHeader_serviceResult};
	$testok{browse_code} = 1 if $result_code == STATUSCODE_GOOD;

	my $results = $data->[1]{BrowseResponse_results};
	$testok{browse_result_count} = 1 if @$results == 1;
	my $refs = $results->[0]{BrowseResult_references};
	$testok{browse_refs_count} = 1 if @$refs == 4;

	$testok{browse_refs_foldertype} = 1
	    if $refs->[0]{ReferenceDescription_displayName}{text} eq 'FolderType';
	$testok{browse_refs_objects} = 1
	    if $refs->[1]{ReferenceDescription_displayName}{text} eq 'Objects';
	$testok{browse_refs_types} = 1
	    if $refs->[2]{ReferenceDescription_displayName}{text} eq 'Types';
	$testok{browse_refs_views} = 1
	    if $refs->[3]{ReferenceDescription_displayName}{text} eq 'Views';

	$r = $c->disconnect();
	$testok{disconnect} = 1 if $r == STATUSCODE_GOOD;
	$testok{state_disconnected} = 1
	    if $c->getState == CLIENTSTATE_DISCONNECTED;
    }
} "leak browse_service callback/data";

ok($testok{$_->[0]}, $_->[1]) for (@testdesc);

waitpid $pid, 0;

is($?, 0, "server finished");
