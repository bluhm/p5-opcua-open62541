#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;
use OPCUA::Open62541 qw(:all);
use OPCUA::Open62541::Client qw(get_mapping_nodeclass_attributeid);

my $have_yaml = eval { require YAML::XS; };

$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent = 1;

my %attributeid_names = get_mapping_attributeid_names();
my %nodeclass_attributeid = get_mapping_nodeclass_attributeid();
my ($client, @queue, %cache);

my $url = $ARGV[0] // 'opc.tcp://127.0.0.1:4840/';

sub init_client {
    $client = OPCUA::Open62541::Client->new();
    my $client_config = $client->getConfig();

    # ignore open62541 messages
    my $logger = $client_config->getLogger();
    $logger->setCallback(sub {}, undef, undef);

    $client_config->setDefault();
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
