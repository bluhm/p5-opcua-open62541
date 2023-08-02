use strict;
use warnings;
use OPCUA::Open62541 qw(:STATUSCODE);
use OPCUA::Open62541::Test::Server;
use OPCUA::Open62541::Test::Client;
use OPCUA::Open62541::Test::CA;

use Test::More tests => 23;
use Test::Exception;
use Test::LeakTrace;
use Test::NoWarnings;
use Test::Warn;

my $server = OPCUA::Open62541::Test::Server->new();
my $serverconfig = $server->{server}->getConfig();

lives_and { is
    $serverconfig->setAccessControl_default(0, undef, undef, undef),
    STATUSCODE_GOOD
} "undef good";
no_leaks_ok {
    $serverconfig->setAccessControl_default(0, undef, undef, undef)
} "undef leak";

lives_and { is
    $serverconfig->setAccessControl_default(1, undef, undef, undef),
    STATUSCODE_GOOD
} "anon good";
no_leaks_ok {
    $serverconfig->setAccessControl_default(1, undef, undef, undef)
} "anon leak";

my $verify = OPCUA::Open62541::CertificateVerification->new();
ok($verify, "verification new");
my $sc = $verify->Trustlist(undef, undef, undef);
is($sc, STATUSCODE_GOOD, "trustlist good");

throws_ok {
    $serverconfig->setAccessControl_default(0, $verify, undef, undef),
} qr/VerifyX509 needs userTokenPolicyUri/, "verify undef";
no_leaks_ok { eval {
    $serverconfig->setAccessControl_default(0, $verify, undef, undef)
} } "verify undef leak";

lives_and { is
    $serverconfig->setAccessControl_default(0, $verify, "uri", undef),
    STATUSCODE_GOOD
} "verify good";
no_leaks_ok {
    $serverconfig->setAccessControl_default(0, $verify, "uri", undef)
} "verify leak";

lives_and { is
    $serverconfig->setAccessControl_default(0, undef, "uri", undef),
    STATUSCODE_GOOD
} "uri good";
no_leaks_ok {
    $serverconfig->setAccessControl_default(0, undef, "uri", undef)
} "uri leak";

lives_and { is
    $serverconfig->setAccessControl_default(0, undef, undef, []),
    STATUSCODE_GOOD
} "login empty good";
no_leaks_ok {
    $serverconfig->setAccessControl_default(0, undef, undef, [])
} "login empty leak";

my @login = (
    {
	UsernamePasswordLogin_username => "user",
	UsernamePasswordLogin_password => "pass",
    },
);

throws_ok {
    $serverconfig->setAccessControl_default(0, undef, undef, \@login),
} qr/UsernamePasswordLogin needs userTokenPolicyUri/, "login undef";
no_leaks_ok { eval {
    $serverconfig->setAccessControl_default(0, undef, undef, \@login)
} } "login undef leak";

lives_and { is
    $serverconfig->setAccessControl_default(0, undef, "uri", \@login),
    STATUSCODE_GOOD
} "login good";
no_leaks_ok {
    $serverconfig->setAccessControl_default(0, undef, "uri", \@login)
} "login leak";

push @login, { UsernamePasswordLogin_username => "passmiss" };

throws_ok {
    $serverconfig->setAccessControl_default(0, undef, "uri", \@login),
} qr/No UsernamePasswordLogin_password in HASH/, "login passmiss";
no_leaks_ok { eval {
    $serverconfig->setAccessControl_default(0, undef, "uri", \@login)
} } "login passmiss leak";
