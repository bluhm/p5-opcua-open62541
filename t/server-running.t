use strict;
use warnings;
use OPCUA::Open62541 ':all';
use POSIX qw(sigaction SIGALRM);

use Test::More tests => 10;
use Test::LeakTrace;
use Test::NoWarnings;

ok(my $server = OPCUA::Open62541::Server->new(), "server");
ok(my $config = $server->getConfig(), "config");

is($config->setDefault(), STATUSCODE_GOOD, "default");

# reset running after 1 second in signal handler
my $running = 1;
sub handler {
    $running = 0;
}
# Perl signal handler only works between perl statements.
# Use the real signal handler to interrupt the OPC UA server.
# This is not signal safe, best effort is good enough for a test.
ok(my $sigact = POSIX::SigAction->new(\&handler), "sigact");
ok(sigaction(SIGALRM, $sigact), "sigaction") or diag "sigaction failed: $!";
ok(defined(alarm(1)), "alarm") or diag "alarm failed: $!";

# run server and stop after one second
is($server->run($running), STATUSCODE_GOOD, "run");
# server run should only return after the handler was called
is($running, 0, "running");

no_leaks_ok { $server->run($running) } "run leak";

# the running variable should not be magical anymore
# unclear how to test that, but a simple store should work
$running = 2;
