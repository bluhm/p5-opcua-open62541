use strict;
use warnings;
use OPCUA::Open62541;

use Test::More tests => 43;
use Test::Exception;
use Test::LeakTrace;
use Test::NoWarnings;

use IO::Socket::SSL::Utils;

my ($cert, $key) = CERT_create(
    CA => 1,
    not_after => time() + 365*24*60*60,
    subject => { commonName => 'OPCUA::Open62541 Test Client selfsigned' },
    ext => [{sn => "subjectAltName", data => "URI:urn:client.p5-opcua-open65241"}],
);

my $cert_pem = PEM_cert2string($cert);
my $key_pem  = PEM_key2string($key);

# open62541 logs errors if security policies are set multiple times for a client
# config. For this reason we create clients and configs in separate blocks for
# the sub tests.

# test setDefaultEncryption() - fail
{
    ok(my $client = OPCUA::Open62541::Client->new(), "client new");
    ok(my $config = $client->getConfig(), "config get");

    throws_ok { OPCUA::Open62541::ClientConfig::setDefaultEncryption() }
	(qr/OPCUA::Open62541::ClientConfig::setDefaultEncryption\(config, localCertificate, privateKey, .*\) /,
	"config missing");
    no_leaks_ok { eval { OPCUA::Open62541::ClientConfig::setDefaultEncryption() } }
	"config missing leak";

    throws_ok { OPCUA::Open62541::ClientConfig::setDefaultEncryption(1, $cert, $key) }
	(qr/Self config is not a OPCUA::Open62541::ClientConfig /,
	"config type");
    no_leaks_ok { eval { OPCUA::Open62541::ClientConfig::setDefaultEncryption(1, $cert, $key) } }
	"config type leak";
}

# test setDefaultEncryption() - invalid certificate
{
    ok(my $client = OPCUA::Open62541::Client->new(), "client new");
    ok(my $config = $client->getConfig(), "config get");
    is($config->setDefaultEncryption("foo", "bar"), "Good", "encryption invalid cert");
}

# test setDefaultEncryption() - invalid certificate leak
no_leaks_ok {
    my $client = OPCUA::Open62541::Client->new();
    my $config = $client->getConfig();
    $config->setDefaultEncryption("foo", "bar");
} "encryption invalid cert leak";

# test setDefaultEncryption() - valid certificate
{
    ok(my $client = OPCUA::Open62541::Client->new(), "client new");
    ok(my $config = $client->getConfig(), "config get");
    is($config->setDefaultEncryption($cert_pem, $key_pem), "Good", "encryption valid");
}

# test setDefaultEncryption() - valid certificate leak
no_leaks_ok {
    my $client = OPCUA::Open62541::Client->new();
    my $config = $client->getConfig();
    $config->setDefaultEncryption($cert_pem, $key_pem);
} "encryption valid leak";

# test setDefaultEncryption() - empty trustList
{
    ok(my $client = OPCUA::Open62541::Client->new(), "client new");
    ok(my $config = $client->getConfig(), "config get");
    is($config->setDefaultEncryption($cert_pem, $key_pem, []), "Good", "encryption empty trustList");
}

# test setDefaultEncryption() - empty trustList leak
no_leaks_ok {
    my $client = OPCUA::Open62541::Client->new();
    my $config = $client->getConfig();
    $config->setDefaultEncryption($cert_pem, $key_pem, []);
} "encryption empty trustList leak";

# test setDefaultEncryption() - invalid trustList
{
    ok(my $client = OPCUA::Open62541::Client->new(), "client new");
    ok(my $config = $client->getConfig(), "config get");
    is($config->setDefaultEncryption($cert_pem, $key_pem, [undef]), "BadInternalError", "encryption invalid trustList");
}

# test setDefaultEncryption() - invalid trustList leak
no_leaks_ok {
    my $client = OPCUA::Open62541::Client->new();
    my $config = $client->getConfig();
    $config->setDefaultEncryption($cert_pem, $key_pem, [undef]);
} "encryption invalid trustList leak";

# test setDefaultEncryption() - valid trustList
{
    ok(my $client = OPCUA::Open62541::Client->new(), "client new");
    ok(my $config = $client->getConfig(), "config get");
    is($config->setDefaultEncryption($cert_pem, $key_pem, [$cert_pem, $cert_pem]), "Good", "encryption valid trustList");
}

# test setDefaultEncryption() - valid trustList leak
no_leaks_ok  {
    my $client = OPCUA::Open62541::Client->new();
    my $config = $client->getConfig();
    $config->setDefaultEncryption($cert_pem, $key_pem, [$cert_pem, $cert_pem]);
} "encryption valid trustList leak";

# test setDefaultEncryption() - empty revocationList
{
    ok(my $client = OPCUA::Open62541::Client->new(), "client new");
    ok(my $config = $client->getConfig(), "config get");
    is($config->setDefaultEncryption($cert_pem, $key_pem, [$cert_pem], []), "Good", "encryption empty revocationList");
}

# test setDefaultEncryption() - empty revocationList leak
no_leaks_ok {
    my $client = OPCUA::Open62541::Client->new();
    my $config = $client->getConfig();
    $config->setDefaultEncryption($cert_pem, $key_pem, [$cert_pem], []);
} "encryption empty revocationList leak";

# test setDefaultEncryption() - invalid revocationList
{
    ok(my $client = OPCUA::Open62541::Client->new(), "client new");
    ok(my $config = $client->getConfig(), "config get");
    is($config->setDefaultEncryption($cert_pem, $key_pem, [$cert_pem], [undef]), "BadInternalError", "encryption invalid revocationList");
}

# test setDefaultEncryption() - invalid revocationList leak
no_leaks_ok {
    my $client = OPCUA::Open62541::Client->new();
    my $config = $client->getConfig();
    $config->setDefaultEncryption($cert_pem, $key_pem, [$cert_pem], [undef]);
} "encryption invalid revocationList leak";

# xxx at the moment we pass "foo" as a CRL until we can generate or read a
#     correct CRL for tests. this causes a BadInternalError Statuscode

# test setDefaultEncryption() - valid revocationList
{
    ok(my $client = OPCUA::Open62541::Client->new(), "client new");
    ok(my $config = $client->getConfig(), "config get");
    is($config->setDefaultEncryption($cert_pem, $key_pem, [$cert_pem, $cert_pem], ["foo"]), "BadInternalError", "encryption valid revocationList");
}

# test setDefaultEncryption() - valid revocationList leak
no_leaks_ok {
    my $client = OPCUA::Open62541::Client->new();
    my $config = $client->getConfig();
    $config->setDefaultEncryption($cert_pem, $key_pem, [$cert_pem, $cert_pem], ["foo"]);
} "encryption valid revocationList leak";

# test setDefaultEncryption() - valid revocationList no trustList
{
    ok(my $client = OPCUA::Open62541::Client->new(), "client new");
    ok(my $config = $client->getConfig(), "config get");
    is($config->setDefaultEncryption($cert_pem, $key_pem, undef, ["foo"]), "BadInternalError", "encryption valid revocationList");
}

# test setDefaultEncryption() - valid revocationList no trustList leak
no_leaks_ok {
    my $client = OPCUA::Open62541::Client->new();
    my $config = $client->getConfig();
    $config->setDefaultEncryption($cert_pem, $key_pem, undef, ["foo"]);
} "encryption valid revocationList leak";
