use strict;
use warnings;
use OPCUA::Open62541 ':all';

use IO::Socket::SSL::Utils;
use MIME::Base64;
use OPCUA::Open62541::Test::Server;
use OPCUA::Open62541::Test::Client;
use Test::More;
BEGIN {
    if(OPCUA::Open62541::ServerConfig->can('setDefaultWithSecurityPolicies')) {
	plan tests =>
	    OPCUA::Open62541::Test::Server::planning() +
	    OPCUA::Open62541::Test::Client::planning() + 4;
    } else {
	plan skip_all => 'open62541 without UA_ENABLE_ENCRYPTION';
    }
}
use Test::LeakTrace;
use Test::NoWarnings;

my %certs;
@{$certs{server}}{qw(cert key)} = CERT_create(
    CA => 1,
    not_after => time() + 365*24*60*60,
    subject => { commonName => 'OPCUA::Open62541 Test Server' },
    ext => [{sn => "subjectAltName", data => 'DNS:localhost,URI:urn:open62541.server.application'}],
);

@{$certs{client}}{qw(cert key)} = CERT_create(
    CA => 1,
    not_after => time() + 365*24*60*60,
    subject => { commonName => 'OPCUA::Open62541 Test Client' },
    ext => [{sn => "subjectAltName", data => 'DNS:localhost,URI:urn:open62541.client.application'}],
);

# use MIME::Base64 to decode the PEM data into DER
for my $t (qw(server client)) {
    for (
	['cert', \&PEM_cert2string],
	['key',  \&PEM_key2string],
    ) {
	my $pem = $_->[1]->($certs{$t}{$_->[0]});
	my ($data) = $pem =~ /^-----BEGIN\ [^-]+-----
	    (.*)
	    ^-----END\ [^-]+-----/msx;
	$certs{$t}{"$_->[0]_der"} = decode_base64($data);
    }
}

my $status;
my $server = OPCUA::Open62541::Test::Server->new(
    certificate => $certs{server}{cert_der},
    privateKey  => $certs{server}{key_der},
);

my $serverconfig = $server->{server}->getConfig();
$server->start();

my $client = OPCUA::Open62541::Test::Client->new(
    port => $server->port(),
    certificate => $certs{client}{cert_der},
    privateKey  => $certs{client}{key_der},
);
my $clientconfig = $client->{client}->getConfig();
$client->start();

$clientconfig->setSecurityMode(MESSAGESECURITYMODE_SIGNANDENCRYPT);

$server->run();

is($client->{client}->connect($client->url()), STATUSCODE_GOOD,
    "client connect success");
$client->stop;

$server->stop;

my $secpol = "Basic128Rsa15";

ok($client->{log}->loggrep("Selected endpoint .* with SecurityMode SignAndEncrypt and SecurityPolicy .*#$secpol"),
   "client: endpoint SignAndEncrypt");
ok($client->{log}->loggrep("Selected UserTokenPolicy .* with UserTokenType Anonymous and SecurityPolicy .*#$secpol"),
   "client: UserTokenPolicy anonymous");

ok($server->{log}->loggrep("SecureChannel opened with SecurityPolicy .*#$secpol"),
    "server: secure channel with security policy");
