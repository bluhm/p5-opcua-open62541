use strict;
use warnings;
use OPCUA::Open62541;

use Test::More tests => 3;
use Test::LeakTrace;

# show how server and its config are expected to be allocated
{
    # keep global server config longer than the server
    my $cg;
    {
	# create server object
	my $s = OPCUA::Open62541::Server->new();
	ok($s, "server new");

	# the config object directly uses data from the server
	# creating a config increases the server reference count
	my $c = $s->getConfig();
	ok($c, "config get");
	# copy of the config has no effect on the UA data structues
	$cg = $c;
	# the server goes out of scope, but it is reference by the config
    }
    # both config and its server have valid memory
    is($cg->setDefault(), STATUSCODE_GOOD, "good");
    # config goes out of scope, it derefeneces the server
    # the server is destroyed
    # the config is destroyed
}
