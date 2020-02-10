use strict;
use warnings;
use OPCUA::Open62541;

use Test::More tests => 6;

my $s = OPCUA::Open62541::Server->new();
ok(defined($s), "server defined");
ok($s, "server new");
is(ref($s), "OPCUA::Open62541::Server", "class");

eval { OPCUA::Open62541::Server::new() };
ok($@, "class missing");
like($@, qr/OPCUA::Open62541::Server::new\(class\)/, "class missing error");

ok(OPCUA::Open62541::Server::new(undef), "class undef");
