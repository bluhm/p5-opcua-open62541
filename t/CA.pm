package OPCUA::Open62541::Test::CA;

use autodie;
use strict;
use warnings;

use Cwd qw(abs_path);
use File::Path qw(make_path remove_tree);
use IO::Socket::SSL::Utils;


sub new {
    my ($class, %args) = @_;

    my $dir = delete($args{dir}) || './t/ca';
    $dir = abs_path($dir)
	or die "no directory";

    my $config = delete($args{config})
	|| _default_openssl_config($dir);

    my $self = bless {
	config => $config,
	dir => $dir,
    }, $class;

    return $self;
}

sub setup {
    my ($self) = @_;
    my $dir = $self->{dir};

    remove_tree($dir);
    make_path($dir);

    for (
	["$dir/crlnumber",   "01\n"],
	["$dir/index.txt",   ""],
	["$dir/openssl.cnf", $self->{config}],
	["$dir/serial",      "01\n"],
    ) {
	open(my $fh, '>', $_->[0]);
	print $fh $_->[1];
    }
}

sub create_cert_root {
    my ($self, %args) = @_;

    $self->create_cert(
	name => "root",
	%args,
    );
}

sub create_cert_client {
    my ($self, %args) = @_;

    $self->create_cert(
	name => "client",
	create_args => {
	    ext => [{sn => "subjectAltName", data => "URI:urn:client.p5-opcua-open65241"}],
	},
	%args,
    );
}

sub create_cert_server {
    my ($self, %args) = @_;

    $self->create_cert(
	name => "server",
	create_args => {
	    ext => [{sn => "subjectAltName", data => "URI:urn:server.p5-opcua-open65241"}],
	},
	%args,
    );
}

sub create_cert {
    my ($self, %args) = @_;
    my $issuer      = delete($args{issuer});
    my $name        = delete($args{name}) || die "no name for cert";
    my $subject     = delete($args{subject}) // {commonName => $name};
    my $create_args = delete($args{create_args}) // {};
    my $dir         = $self->{dir};

    if ($issuer and not ref $issuer) {
	$issuer = [@{$self->{certs}{$issuer}}{qw(cert key)}];
    } elsif ($issuer and ref($issuer) eq 'HASH') {
	$issuer = [@$issuer{qw(cert key)}];
    }

    my $is_ca = !$issuer;
    my ($cert, $key) = CERT_create(
	not_after => time() + 365*24*60*60,
	subject => $subject,
	$issuer ? (issuer => $issuer) : (),
	$is_ca ? (CA => 1, purpose => 'sslCA,cRLSign') : (),
	%$create_args,
    );

    my $path_cert = "$dir/$name.cert";
    my $path_crl = "$dir/$name.crl";
    my $path_key = "$dir/$name.key";

    PEM_cert2file($cert, $path_cert);
    PEM_key2file($key, $path_key);

    my $crl;
    if ($is_ca) {
	$crl = qx(openssl ca -config "$dir/openssl.cnf" -cert "$path_cert" -keyfile "$path_key" -gencrl 2>&1);

	open my $fh, ">", $path_crl;
	print $fh $crl;
	close $fh;
    }

    $self->{certs}{$name} = {
	cert     => $cert,
	cert_pem => PEM_cert2string($cert),
	key      => $key,
	key_pem  => PEM_key2string($key),
	$is_ca ? (crl_pem => $crl) : (),
    };
}

sub _default_openssl_config {
    my $dir = shift;
    my $config = << 'CONF';
[ ca ]
default_ca  = CA_default

[ CA_default ]
dir         = %DIR%
database    = $dir/index.txt
serial      = $dir/serial
crlnumber   = $dir/crlnumber

default_days     = 365
default_crl_days = 30
default_md  = sha256
CONF

    $config =~ s/%DIR%/$dir/g;

    return $config;
}


1;
