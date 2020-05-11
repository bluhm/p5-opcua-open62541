#!/usr/bin/perl
# Generate packages with destroy functions

use strict;
use warnings;

my @types = qw(
    UInt32
    String
    ByteString
    BrowseDescription
    BrowseNextRequest
    BrowseRequest
    NodeId
    ExpandedNodeId
    LocalizedText
    QualifiedName
    Variant
    DataTypeAttributes
    ObjectAttributes
    ObjectTypeAttributes
    ReferenceTypeAttributes
    VariableAttributes
    VariableTypeAttributes
    ViewAttributes
);

open(my $tf, '>', "Open62541-typedef.xsh")
    or die "Open 'Open62541-typedef.xsh' for writing failed: $!";
open(my $pf, '>', "Open62541-destroy.xsh")
    or die "Open 'Open62541-destroy.xsh' for writing failed: $!";

foreach my $type (@types) {
    print_xstypedef($tf, $type);
    print_xspackage($pf, $type);
}

close($tf)
    or die "Close 'Open62541-typedef.xsh' after writing failed: $!";
close($pf)
    or die "Close 'Open62541-destroy.xsh' after writing failed: $!";

exit(0);

########################################################################
sub print_xstypedef {
    my ($xsf, $type) = @_;
    (my $var = $type) =~ s/^./lc($&)/e;
    print $xsf <<"EOXSTDEF";
typedef UA_$type *		OPCUA_Open62541_$type;
EOXSTDEF
}

########################################################################
sub print_xspackage {
    my ($xsf, $type) = @_;
    (my $var = $type) =~ s/^./lc($&)/e;
    print $xsf <<"EOXSPACK";
MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::$type	PREFIX = UA_${type}_

void
UA_${type}_DESTROY($var)
	OPCUA_Open62541_${type}	$var
    CODE:
	DPRINTF("$var %p", $var);
	UA_${type}_delete($var);

EOXSPACK
}
