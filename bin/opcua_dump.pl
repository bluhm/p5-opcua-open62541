#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;
use Getopt::Std;
use OPCUA::Open62541 qw(:all);
use OPCUA::Open62541::Client qw(get_mapping_nodeclass_attributeid);

######################################################################
# configuration
######################################################################

my $usage = "Usage: $0 [-C configfile] [URL]\n";

my %opt;
die $usage if not getopts("C:", \%opt);

# config_helper defines available values, their default values and their
# validating functions
my %config_helper = (
    client_timeout => {
	default => 5000,
	validate => sub {
	    return 'has to be a scalar' if ref $_[0];
	    return "'$_[0]' is not a number" if ($_[0] // '') !~ /^[0-9]+$/;
	},
    },
);
my %config;

# check if we can output via YAML::XS
my $have_yaml = eval { require YAML::XS; };

my $config_file = $opt{C};
$config_file = '.opcua_dump'
    if not defined $opt{C} and -r '.opcua_dump';

if (not $have_yaml and defined $config_file) {
    die "missing YAML support for config file\n";
} elsif (defined $config_file) {
    my $yaml = YAML::XS::LoadFile($config_file);

    # filter unknown keys by lookup in %config_helper
    for (sort keys %$yaml) {
	die "config - unknown key: $_"
	    if not exists $config_helper{$_};
	$config{$_} = $yaml->{$_};
    }
}

# set missing keys to default values from %config_helper
for (sort keys %config_helper) {
    next if exists $config{$_};
    $config{$_} = $config_helper{$_}{default};
}

# call validate functions for keys / values
for (sort keys %config) {
    my $err = $config_helper{$_}{validate}->($config{$_});
    die "config - $_: $err\n" if $err;
}

my $url = $ARGV[0] // 'opc.tcp://127.0.0.1:4840/';

# make Dumper output more consistent and readable
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent = 1;

######################################################################
# opc ua
######################################################################

my %attributeid_names = get_mapping_attributeid_names();
my %nodeclass_attributeid = get_mapping_nodeclass_attributeid();
my ($client, @queue, %cache);

sub init_client {
    $client = OPCUA::Open62541::Client->new();
    my $client_config = $client->getConfig();

    # ignore open62541 messages
    my $logger = $client_config->getLogger();
    $logger->setCallback(sub {}, undef, undef);

    $client_config->setDefault();
    $client_config->setTimeout($config{client_timeout});

    my $status = $client->connect($url);

    die "connect failed: $status"
	if $status ne 'Good';
}

sub get_all {
    my $nodeid = shift;

    my $data = {
	nodeId => $nodeid,
	attributes => {},
	references => [],
    };

    $cache{$nodeid->{NodeId_print}} = 1;

    my ($response) = $client->get_attributes($nodeid, ATTRIBUTEID_NODECLASS);
    $data->{attributes}{nodeclass} = $response;

    my $nodeclass = $response->{DataValue_value}{Variant_scalar};

    my @requests = grep { $_ ne 'nodeclass' }
	map { $attributeid_names{$_} }
	keys %{$nodeclass_attributeid{$nodeclass} // {}};

    for (@requests) {
	($data->{attributes}{$_}) = $client->get_attributes($nodeid, $_);
    }

    # browse references
    for ($client->get_references($nodeid)) {
	my $expid = $_->{ReferenceDescription_nodeId};
	if ($expid->{ExpandedNodeId_serverIndex}) {
	    # ignore remote reference
	    next;
	}
	my $nodeid = $expid->{ExpandedNodeId_nodeId};
	push @{$data->{references}}, $_;
    }

    return $data;
}

sub dump_opcua {
    my $nodeid = shift @queue;

    return if not $nodeid;
    return if $cache{$nodeid->{NodeId_print}};

    my $data = get_all($nodeid);

    if ($have_yaml) {
	print YAML::XS::Dump($data);
    } else {
	print Dumper $data;
    }

    for (@{$data->{references}}) {
	my $expid = $_->{ReferenceDescription_nodeId}{ExpandedNodeId_nodeId};
	next if $cache{$expid->{NodeId_print}};
	push @queue, $expid;
    }
}

######################################################################
# main
######################################################################

init_client;

@queue = ({
    NodeId_namespaceIndex => 0,
    NodeId_identifierType => 0,
    NodeId_identifier => OPCUA::Open62541::NS0ID_ROOTFOLDER,
    NodeId_print => 'i=' . OPCUA::Open62541::NS0ID_ROOTFOLDER,
});

while (@queue) {
    dump_opcua;
}


__END__

=pod

=head1 NAME

B<opcua_dump> - dump data from an OPC UA server

=head1 SYNOPSIS

B<opcua_dump> [-C configfile] [URL]

=head1 DESCRIPTION

B<opcua_dump> connects to an OPC UA server and recursively browses the OPC UA
address space starting from the root folder (i=84).
Read requests are made for the nodes for each attribute depending on the
nodeclass.

The attributes and references are printed to STDOUT.

The output format is YAML if I<YAML::XS> can be loaded. Otherwise the data will be
formattted with I<Data::Dumper>.

I<URL> has to be a OPC UA endpoint URL.
If none is specified I<opc.tcp://127.0.0.1:4840/> will be used.

The options are as follows:

=over 4

=item B<-C configfile>

Read a config file from the specified path.
If no config file was specified and a readable I<.opcua_dump> file is found in the
current directory, that will be used.

=back

=head1 CONFIGFILE

The config file should be a YAML hash. The following options are available:

=over 4

=item client_timeout

Specify the inactivity timeout in milliseconds.

The default value is 5000ms.

=back

=head1 SEE ALSO

OPCUA::Open62541

OPC UA library, L<https://open62541.org/>

=head1 AUTHORS

Alexander Bluhm E<lt>bluhm@genua.deE<gt>,
Anton Borowka

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2025 Alexander Bluhm

Copyright (c) 2025 Anton Borowka

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

Thanks to genua GmbH, https://www.genua.de/ for sponsoring this work.

=cut
