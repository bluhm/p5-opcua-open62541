use strict;
use warnings;
use OPCUA::Open62541;

use Test::More tests => 50;
use Test::Exception;
use Test::NoWarnings;

my $log_context;
my $log_calls = 0;
sub log {
    my ($context, $level, $category, $message) = @_;
    $log_calls++;
    $log_context = $context;
}

my $clear_context;
my $clear_calls = 0;
sub clear {
    my ($context) = @_;
    $clear_calls++;
    $clear_context = $context;
}

# one server, one config, one logger, set callback twice
{
    ok(my $server = OPCUA::Open62541::Server->new(), "server");
    {
	ok(my $config = $server->getConfig(), "config");
	ok(my $logger = $config->getLogger(), "logger");
	$logger->logWarning(1, "no callback");
	is($log_calls, 0, "no log call");
	is($log_context, undef, "no context");
	$logger->setCallback(\&log, "first", \&clear);
	$logger->logWarning(1, "first callback");
	is($log_calls, 1, "first log call");
	is($log_context, "first", "first context");
	$logger->setCallback(\&log, "second", \&clear);
	$logger->logWarning(1, "second callback");
	is($log_calls, 2, "second log call");
	is($log_context, "second", "second context");
    }
    is($clear_calls, 0, "logger scope");

    is($log_calls, 2, "logger begin");
    $server->run_startup();
    $server->run_iterate(0);
    $server->run_shutdown();
    isnt($log_calls, 2, "logger end");
}
is($clear_calls, 1, "server scope");
is($clear_context, "second", "clear context");

$log_calls = $clear_calls = 0;
$log_context = $clear_context = undef;

# one server, one config, two logger, set callback twice
{
    ok(my $server = OPCUA::Open62541::Server->new(), "two logger: server");
    {
	ok(my $config = $server->getConfig(), "two logger: config");
	ok(my $logger1 = $config->getLogger(), "two logger: logger");
	$logger1->logWarning(1, "two logger: no callback");
	is($log_calls, 0, "two logger: no log call");
	is($log_context, undef, "two logger: no context");
	$logger1->setCallback(\&log, "first", \&clear);
	$logger1->logWarning(1, "two logger: first callback");
	is($log_calls, 1, "two logger: first log call");
	is($log_context, "first", "two logger: first context");
	ok(my $logger2 = $config->getLogger(), "two logger: logger");
	$logger2->logWarning(1, "two logger: first callback 2");
	is($log_calls, 2, "two logger: first log call 2");
	is($log_context, "first", "two logger: first context 2");
	$logger2->setCallback(\&log, "second", \&clear);
	$logger2->logWarning(1, "two logger: second callback");
	is($log_calls, 3, "two logger: second log call");
	is($log_context, "second", "two logger: second context");
    }
    is($clear_calls, 0, "two logger: logger scope");

    is($log_calls, 3, "two logger: logger begin");
    $server->run_startup();
    $server->run_iterate(0);
    $server->run_shutdown();
    isnt($log_calls, 3, "two logger: logger end");
}
is($clear_calls, 1, "two logger: server scope");
is($clear_context, "second", "two logger: clear context");

$log_calls = $clear_calls = 0;
$log_context = $clear_context = undef;

# one server, two config, two logger, set callback twice
{
    ok(my $server = OPCUA::Open62541::Server->new(), "server");
    {
	ok(my $config1 = $server->getConfig(), "two config: config 1");
	ok(my $logger1 = $config1->getLogger(), "two config: logger 1");
	$logger1->logWarning(1, "two config: no callback");
	is($log_calls, 0, "two config: no log call");
	is($log_context, undef, "two config: no context");
	$logger1->setCallback(\&log, "first", \&clear);
	$logger1->logWarning(1, "two config: first callback");
	is($log_calls, 1, "two config: first log call");
	is($log_context, "first", "two config: first context");
	ok(my $config2 = $server->getConfig(), "two config: config 2");
	ok(my $logger2 = $config2->getLogger(), "two config: logger 2");
	$logger2->logWarning(1, "two config: first callback");
	is($log_calls, 2, "two config: first log call 2");
	is($log_context, "first", "two config: first context 2");
	$logger2->setCallback(\&log, "second", \&clear);
	$logger2->logWarning(1, "two config: second callback");
	is($log_calls, 3, "two config: second log call");
	is($log_context, "second", "two config: second context");
    }
    is($clear_calls, 0, "two config: logger scope");

    is($log_calls, 3, "two config: logger begin");
    $server->run_startup();
    $server->run_iterate(0);
    $server->run_shutdown();
    isnt($log_calls, 3, "two config: logger end");
}
is($clear_calls, 1, "two config: server scope");
is($clear_context, "second", "two config: clear context");
