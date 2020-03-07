use strict;
use warnings;
use OPCUA::Open62541;

use Test::More tests => 11;
use Test::Exception;
use Test::LeakTrace;
use Test::NoWarnings;
use Test::Warn;

sub nolog {
    my ($context, $level, $category, $message) = @_;
}

sub noclear {
    my ($context) = @_;
}

no_leaks_ok {
    my $logger;
    {
	my $config;
	{
	    my $server = OPCUA::Open62541::Server->new();
	    $config = $server->getConfig();
	}
	$logger = $config->getLogger();
    }
    $logger->setCallback(\&nolog, "storage", \&noclear);
    $logger->logFatal(1, "fatal");
} "leak logger storage";

sub log {
    my ($context, $level, $category, $message) = @_;
    is($context, "server", "log context");
    is($level, 3, "log level");
    is($category, 3, "log category");
    is($message, "There has to be at least one endpoint.", "log message");
}

sub clear {
    my ($context) = @_;
    is($context, "server", "clear context");
}

ok(my $server = OPCUA::Open62541::Server->new(), "server");
ok(my $config = $server->getConfig(), "config");
ok(my $logger = $config->getLogger(), "logger");
lives_ok { $logger->setCallback(\&log, "server", \&clear) } "set log";

$server->run_startup();
$server->run_iterate(100);
$server->run_shutdown();
