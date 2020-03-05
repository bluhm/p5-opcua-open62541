use strict;
use warnings;
use OPCUA::Open62541;

use Test::More tests => 32;
use Test::NoWarnings;
use Test::Exception;;
use Test::LeakTrace;
use Test::Warn;

lives_ok { OPCUA::Open62541::Logger->new() } "live new";
no_leaks_ok { OPCUA::Open62541::Logger->new() } "leak new";
throws_ok { OPCUA::Open62541::Logger::new("subclass") }
    (qr/Class 'subclass' is not OPCUA::Open62541::Logger/, "new subclass");
no_leaks_ok { eval { OPCUA::Open62541::Logger::new("subclass") } }
    "leak new subclass";
ok(my $logger = OPCUA::Open62541::Logger->new(), "logger new");

lives_ok { $logger->setCallback(undef, undef, undef) } "live setCallback";
no_leaks_ok { $logger->setCallback(undef, undef, undef) } "leak setCallback";

throws_ok { $logger->setCallback("foo", undef, undef) }
    (qr/Log 'foo' is not a CODE reference/, "setCallback noref log");
no_leaks_ok { eval { $logger->setCallback("foo", undef, undef) } }
    "leak setCallback noref log";

throws_ok { $logger->setCallback(undef, undef, "bar") }
    (qr/Clear 'bar' is not a CODE reference/, "setCallback noref clear");
no_leaks_ok { eval { $logger->setCallback(undef, undef, "bar") } }
    "leak setCallback noref clear";

my $calls = 0;
sub log {
    my ($context, $level, $category, $message) = @_;
    if ($calls++ == 0) {
	pass("called once");
	is($context, "context", "context string");
    }
    is($category, 1, "category warning") if $level == 3;
    is($category, 2, "category error") if $level == 4;
    is($category, 3, "category fatal") if $level == 5;
    is($message, "message", "message warning") if $level == 3;
    is($message, "number 7", "message error") if $level == 4;
    is($message, "number 7 string 'foo'", "message fatal") if $level == 5;
    is($message, "msg args %s", "message info") if $level == 2;
}

lives_ok { $logger->setCallback(\&log, "context", undef) }
    "live setCallback log context";
no_leaks_ok {
    OPCUA::Open62541::Logger->new()->setCallback(\&log, "context", undef);
} "leak setCallback log";

lives_ok { $logger->logWarning(1, "message") } "live logWarning message";
lives_ok { $logger->logError(2, "number %d", 7) } "live logError number";
lives_ok { $logger->logFatal(3, "number %d string '%s'", 7, "foo") }
    "live logFatal number string";
lives_ok { $logger->logInfo(0, "msg %s", "args %s") } "live logInfo format";

sub nolog {
    my ($context, $level, $category, $message) = @_;
}

no_leaks_ok {
    $logger->setCallback(\&nolog, undef, undef);
    $logger->logWarning(0, "message");
    $logger->logError(0, "number %d", 7);
    $logger->logFatal(0, "number %d string '%s'", 7, "foo");
} "leak no log";

warning_like { $logger->logError("category", "message") }
    (qr/Argument "category" isn't numeric in subroutine /, "warn category");
warning_like { $logger->logWarning(1, "too many", "foo") }
    (qr/Redundant argument in subroutine /, "warn too many args");
warning_like { $logger->logFatal(1, "too %s few %s", "foo") }
    (qr/Missing argument in subroutine /, "warn too few args");
warning_like { $logger->logInfo(1, "wrong %d type %s", "foo", 7) }
    (qr/Argument "foo" isn't numeric in subroutine /, "warn wrong type args");
