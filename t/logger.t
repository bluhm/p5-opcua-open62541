use strict;
use warnings;
use OPCUA::Open62541;

use Test::More tests => 32;
use Test::Exception;
use Test::LeakTrace;
use Test::NoWarnings;
use Test::Warn;

ok(my $logger = OPCUA::Open62541::Logger->new(), "logger new");
is(ref($logger), "OPCUA::Open62541::Logger", "logger new class");
no_leaks_ok { OPCUA::Open62541::Logger->new() } "logger new leak";

throws_ok { OPCUA::Open62541::Logger::new("subclass") }
    (qr/Class 'subclass' is not OPCUA::Open62541::Logger/, "subclass");
no_leaks_ok { eval { OPCUA::Open62541::Logger::new("subclass") } }
    "subclass leak";

lives_ok { $logger->setCallback(undef, undef, undef) } "setCallback";
no_leaks_ok { $logger->setCallback(undef, undef, undef) } "setCallback leak";

throws_ok { $logger->setCallback("foo", undef, undef) }
    (qr/Log 'foo' is not a CODE reference/, "setCallback noref log");
no_leaks_ok { eval { $logger->setCallback("foo", undef, undef) } }
    "setCallback noref log leak";

throws_ok { $logger->setCallback(undef, undef, "bar") }
    (qr/Clear 'bar' is not a CODE reference/, "setCallback noref clear");
no_leaks_ok { eval { $logger->setCallback(undef, undef, "bar") } }
    "setCallback noref clear leak";

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
    "setCallback log context";
no_leaks_ok {
    OPCUA::Open62541::Logger->new()->setCallback(\&log, "context", undef);
} "setCallback log context leak";

lives_ok { $logger->logWarning(1, "message") } "logWarning message";
lives_ok { $logger->logError(2, "number %d", 7) } "logError number";
lives_ok { $logger->logFatal(3, "number %d string '%s'", 7, "foo") }
    "logFatal number string";
lives_ok { $logger->logInfo(0, "msg %s", "args %s") } "logInfo format";

sub nolog {
    my ($context, $level, $category, $message) = @_;
}

no_leaks_ok {
    $logger->setCallback(\&nolog, undef, undef);
    $logger->logWarning(0, "message");
    $logger->logError(0, "number %d", 7);
    $logger->logFatal(0, "number %d string '%s'", 7, "foo");
} "no log leak";

warning_like { $logger->logError("category", "message") }
    (qr/Argument "category" isn't numeric in subroutine /, "warn category");
warning_like { $logger->logWarning(1, "too many", "foo") }
    (qr/Redundant argument in subroutine /, "warn too many args");
warning_like { $logger->logFatal(1, "too %s few %s", "foo") }
    (qr/Missing argument in subroutine /, "warn too few args");
warning_like { $logger->logInfo(1, "wrong %d type %s", "foo", 7) }
    (qr/Argument "foo" isn't numeric in subroutine /, "warn wrong type args");
