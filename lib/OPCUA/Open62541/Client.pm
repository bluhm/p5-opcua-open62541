package OPCUA::Open62541::Client;

use strict;
use warnings;
require Exporter;
use parent 'Exporter';

use OPCUA::Open62541 qw(:ATTRIBUTEID :BROWSERESULTMASK :NODECLASS :NODEIDTYPE);

my %mapping_nodeclass_attributes;
# Base NodeClass
for (
    NODECLASS_OBJECT,
    NODECLASS_VARIABLE,
    NODECLASS_METHOD,
    NODECLASS_OBJECTTYPE,
    NODECLASS_VARIABLETYPE,
    NODECLASS_REFERENCETYPE,
    NODECLASS_DATATYPE,
    NODECLASS_VIEW
 ) {
    $mapping_nodeclass_attributes{$_}{ATTRIBUTEID_NODEID()} = 'm';
    $mapping_nodeclass_attributes{$_}{ATTRIBUTEID_NODECLASS()} = 'm';
    $mapping_nodeclass_attributes{$_}{ATTRIBUTEID_BROWSENAME()} = 'm';
    $mapping_nodeclass_attributes{$_}{ATTRIBUTEID_DISPLAYNAME()} = 'm';
    $mapping_nodeclass_attributes{$_}{ATTRIBUTEID_DESCRIPTION()} = 'o';
    $mapping_nodeclass_attributes{$_}{ATTRIBUTEID_WRITEMASK()} = 'o';
    $mapping_nodeclass_attributes{$_}{ATTRIBUTEID_USERWRITEMASK()} = 'o';
    $mapping_nodeclass_attributes{$_}{ATTRIBUTEID_ROLEPERMISSIONS()} = 'o';
    $mapping_nodeclass_attributes{$_}{ATTRIBUTEID_USERROLEPERMISSIONS()} = 'o';
    $mapping_nodeclass_attributes{$_}{ATTRIBUTEID_ACCESSRESTRICTIONS()} = 'o';
}

# ReferenceType NodeClass
$mapping_nodeclass_attributes{NODECLASS_REFERENCETYPE()}{ATTRIBUTEID_ISABSTRACT()} = 'm';
$mapping_nodeclass_attributes{NODECLASS_REFERENCETYPE()}{ATTRIBUTEID_SYMMETRIC()} = 'm';
$mapping_nodeclass_attributes{NODECLASS_REFERENCETYPE()}{ATTRIBUTEID_INVERSENAME()} = 'o';

# View NodeClass
$mapping_nodeclass_attributes{NODECLASS_VIEW()}{ATTRIBUTEID_CONTAINSNOLOOPS()} = 'm';
$mapping_nodeclass_attributes{NODECLASS_VIEW()}{ATTRIBUTEID_EVENTNOTIFIER()} = 'm';

# Object NodeClass
$mapping_nodeclass_attributes{NODECLASS_OBJECT()}{ATTRIBUTEID_EVENTNOTIFIER()} = 'm';

# Variable NodeClass
$mapping_nodeclass_attributes{NODECLASS_VARIABLE()}{ATTRIBUTEID_VALUE()} = 'm';
$mapping_nodeclass_attributes{NODECLASS_VARIABLE()}{ATTRIBUTEID_DATATYPE()} = 'm';
$mapping_nodeclass_attributes{NODECLASS_VARIABLE()}{ATTRIBUTEID_VALUERANK()} = 'm';
$mapping_nodeclass_attributes{NODECLASS_VARIABLE()}{ATTRIBUTEID_ARRAYDIMENSIONS()} = 'o';
$mapping_nodeclass_attributes{NODECLASS_VARIABLE()}{ATTRIBUTEID_ACCESSLEVEL()} = 'm';
$mapping_nodeclass_attributes{NODECLASS_VARIABLE()}{ATTRIBUTEID_USERACCESSLEVEL()} = 'm';
$mapping_nodeclass_attributes{NODECLASS_VARIABLE()}{ATTRIBUTEID_MINIMUMSAMPLINGINTERVAL()} = 'o';
$mapping_nodeclass_attributes{NODECLASS_VARIABLE()}{ATTRIBUTEID_HISTORIZING()} = 'm';
$mapping_nodeclass_attributes{NODECLASS_VARIABLE()}{ATTRIBUTEID_ACCESSLEVELEX()} = 'o';

# Method NodeClass
$mapping_nodeclass_attributes{NODECLASS_METHOD()}{ATTRIBUTEID_EXECUTABLE()} = 'm';
$mapping_nodeclass_attributes{NODECLASS_METHOD()}{ATTRIBUTEID_USEREXECUTABLE()} = 'm';

sub get_mapping_nodeclass_attributeid { %mapping_nodeclass_attributes };

our @EXPORT_OK = qw(get_mapping_nodeclass_attributeid);

my %attributeid_ids = OPCUA::Open62541::get_mapping_attributeid_ids;

sub get_namespaces {
    my $self = shift;

    my ($value) = $self->get_attributes({
	NodeId_namespaceIndex => 0,
	NodeId_identifierType => NODEIDTYPE_NUMERIC,
	NodeId_identifier     => OPCUA::Open62541::NS0ID_SERVER_NAMESPACEARRAY,
    }, 'value');

    return @{$value->{DataValue_value}{Variant_array} // []};
}

sub get_attributes {
    my ($self, $nodeid, @attributes) = @_;

    # is there any default that
    die 'no attributes for get_attributes'
	if not @attributes;

    @attributes = map { $attributeid_ids{$_} // $_ } @attributes;

    my $response = $self->Service_read({
	ReadRequest_nodesToRead => [
	    map {
		{ReadValueId_nodeId => $nodeid, ReadValueId_attributeId => $_}
	    } @attributes
	],
    });

    my $status = $response->{"ReadResponse_responseHeader"}{ResponseHeader_serviceResult};
    die "Read failed with $status"
	if $status ne 'Good';

    return @{$response->{ReadResponse_results} // []};
}

sub get_references {
    my ($self, $nodeid, %args) = @_;

    my $result_mask       = $args{result_mask} // BROWSERESULTMASK_NONE;
    my $include_subtypes  = $args{include_subtypes} // 1;
    my $browse_direction  = $args{browse_direction} // 0;
    my $reference_type_id = $args{reference_type_id} // {
	NodeId_namespaceIndex => 0,
	NodeId_identifierType => NODEIDTYPE_NUMERIC,
	NodeId_identifier => OPCUA::Open62541::NS0ID_REFERENCES,
    };

    my $request = {
	BrowseRequest_requestedMaxReferencesPerNode => 0,
	BrowseRequest_nodesToBrowse => [{
	    BrowseDescription_nodeId => $nodeid,
	    BrowseDescription_browseDirection => $browse_direction,
	    BrowseDescription_referenceTypeId => $reference_type_id,
	    BrowseDescription_includeSubtypes => $include_subtypes,
	    BrowseDescription_resultMask => $result_mask,
	}],
    };

    my $type = 'Browse';
    my @references;
  NEXT:
    my $response = $type eq 'Browse' ? $self->Service_browse($request)
	: $self->Service_browseNext($request);

    my $status = $response->{"${type}Response_responseHeader"}{ResponseHeader_serviceResult};
    die "$type failed with $status"
	if $status ne 'Good';

    my $result = $response->{"${type}Response_results"}[0];
    push @references,
	@{$result->{BrowseResult_references} // []};

    if (my $continuation_point = $result->{"BrowseResult_continuationPoint"}) {
	$type = 'BrowseNext';
	$request = {
	    BrowseNextRequest_continuationPoints => [$continuation_point]
	};
	goto NEXT;
    }

    return @references
}

sub get_references_hierarchical {
    get_references(
	@_, reference_type_id => {
	    NodeId_namespaceIndex => 0,
	    NodeId_identifier     => OPCUA::Open62541::NS0ID_HIERARCHICALREFERENCES,
	    NodeId_identifierType => NODEIDTYPE_NUMERIC,
	},
    );
}

1;
