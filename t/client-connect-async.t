use strict;
use warnings;
use OPCUA::Open62541 ':all';
use Scalar::Util qw(looks_like_number);
use Time::HiRes qw(sleep);

use OPCUA::Open62541::Test::Server;
use OPCUA::Open62541::Test::Client;
use Test::More tests => OPCUA::Open62541::Test::Server::planning() + 24;
use Test::Exception;
use Test::NoWarnings;
use Test::LeakTrace;

my $server = OPCUA::Open62541::Test::Server->new();
$server->start();
my $client = OPCUA::Open62541::Test::Client->new(port => $server->port());
$client->start();
$server->run();

my $data = ['foo'];
is($client->{client}->connect_async(
    $client->url(),
    sub {
	my ($c, $d, $i, $r) = @_;
	is($c->getState(), CLIENTSTATE_SESSION, "callback client state");
	is($d->[0], "foo", "callback data in");
	push @$d, 'bar';
	ok(looks_like_number $i, "callback request id")
	    or diag "request id not a number: $i";
	is($r, STATUSCODE_GOOD, "callback response");
    },
    $data
), STATUSCODE_GOOD, "client connect_async");

# loop should not take longer then 5 seconds
my $i;
for ($i = 0; $i < 50; $i++) {
    my $sc = $client->{client}->run_iterate(0);
    if ($sc != STATUSCODE_GOOD) {
	fail "client run_iterate" or diag "run_iterate failed: $sc";
	last;
    }
    if ($client->{client}->getState() == CLIENTSTATE_SESSION) {
	pass "client state session";
	last;
    }
    sleep .1;
}
fail "client loop timeout" if $i == 50;
is($data->[1], "bar", "callback data out");

$client->stop();

$client = OPCUA::Open62541::Test::Client->new(port => $server->port());
$client->start();

# run the test again, check for leaks, no check within leak detection
$data = 0;
my $callback = sub {
    my ($c, $d, $i, $r) = @_;
    # changing $d would have no effect or cause a ref leak
    $data = 1;
};
no_leaks_ok {
    $client->{client}->connect_async(
	$client->url(),
	$callback,
	undef
    );
    for (my $i = 0; $i < 50; $i++) {
	my $sc = $client->{client}->run_iterate(0);
	last if $sc != STATUSCODE_GOOD;
	last if $client->{client}->getState() == CLIENTSTATE_SESSION;
	sleep .1;
    }
} "client connect_async leak";
is($data, 1, "client data");
$client->stop();

$server->stop();

throws_ok { $client->{client}->connect_async($client->url(), "foo", undef) }
    (qr/Callback 'foo' is not a CODE reference /,
    "callback not reference");
no_leaks_ok {
    eval { $client->{client}->connect_async($client->url(), "foo", undef) }
} "callback not reference leak";


throws_ok { $client->{client}->connect_async($client->url(), [], undef) }
    (qr/Callback 'ARRAY.*' is not a CODE reference /,
    "callback not code reference");
no_leaks_ok {
    eval { $client->{client}->connect_async($client->url(), [], undef) }
} "callback not code reference leak";

# the connection itself gets established in run_iterate. so this call should
# also succeed if no server is running
is($client->{client}->connect_async($client->url(), undef, undef),
    STATUSCODE_GOOD, "connect_async no callback");
no_leaks_ok { $client->{client}->connect_async($client->url(), undef, undef) }
    "connect_async no callback leak";
