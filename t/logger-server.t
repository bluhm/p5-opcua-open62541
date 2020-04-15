use strict;
use warnings;
use OPCUA::Open62541;

use Test::More tests => 16;
use Test::Exception;
use Test::NoWarnings;

my $log_calls = 0;
sub log {
    my ($context, $level, $category, $message) = @_;
    return if $log_calls++;
    is($log_calls, 1, "log once");
    is($context, "server", "log context");
    is($level, "warn", "log level");
    is($category, "server", "log category");
    is($message, "There has to be at least one endpoint.", "log message");
}

my $clear_calls = 0;
sub clear {
    my ($context) = @_;
    $clear_calls++;
    is($clear_calls, 1, "clear once");
    is($context, "server", "clear context");
}

{
    ok(my $server = OPCUA::Open62541::Server->new(), "server");
    {
	ok(my $config = $server->getConfig(), "config");
	ok(my $logger = $config->getLogger(), "logger");
	lives_ok { $logger->setCallback(\&log, "server", \&clear) } "set log";
    }
    is($clear_calls, 0, "logger scope");

    is($log_calls, 0, "logger begin");
    $server->run_startup();
    $server->run_iterate(0);
    $server->run_shutdown();
    isnt($log_calls, 0, "logger begin");
}
is($clear_calls, 1, "server scope");
