use strict;
use warnings;
use OPCUA::Open62541;

use Test::More tests => 3;
use Test::LeakTrace;

{
    # keep global server config longer than server
    my $cg;
    {
	my $s = OPCUA::Open62541::Server->new();
	ok($s, "server new");

	my $c = $s->getConfig();
	ok($c, "config get");
	$cg = $c;
    }
    is($cg->setDefault(), STATUSCODE_GOOD, "good");
}
