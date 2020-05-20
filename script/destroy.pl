#!/usr/bin/perl
# Generate typedefs and packages with destroy functions.

use strict;
use warnings;

my @types = qw(
    Boolean
    Byte
    Int32
    UInt32
    Double
    String
    ByteString
    BrowseDescription
    BrowseNextRequest
    BrowseRequest
    ReadRequest
    NodeId
    ExpandedNodeId
    LocalizedText
    QualifiedName
    Variant
    NodeClass
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
print $tf "/* begin generated by $0 */\n\n";
open(my $pf, '>', "Open62541-destroy.xsh")
    or die "Open 'Open62541-destroy.xsh' for writing failed: $!";
print $pf "# begin generated by $0\n\n";

foreach my $type (sort @types) {
    print_xstypedef($tf, $type);
    print_xspackage($pf, $type);
}

print $tf "\n/* end generated by $0 */\n";
close($tf)
    or die "Close 'Open62541-typedef.xsh' after writing failed: $!";
print $pf "# end generated by $0\n";
close($pf)
    or die "Close 'Open62541-destroy.xsh' after writing failed: $!";

exit(0);

########################################################################
sub print_xstypedef {
    my ($xsf, $type) = @_;
    print $xsf <<"EOXSTDEF";
typedef UA_$type *		OPCUA_Open62541_$type;
EOXSTDEF
}

########################################################################
sub print_xspackage {
    my ($xsf, $type) = @_;
    (my $var = $type) =~ s/^./lc($&)/e;
    $var =~ s/^double$/double_/;  # double is a C keyword
    print $xsf "MODULE = OPCUA::Open62541\t";
    print $xsf "PACKAGE = OPCUA::Open62541::$type\t";
    print $xsf "PREFIX = UA_${type}_\n\n";
    print $xsf <<"EOXSPACK";
void
UA_${type}_DESTROY($var)
	OPCUA_Open62541_${type}	$var
    CODE:
	DPRINTF("$var %p", $var);
	UA_${type}_delete($var);

EOXSPACK
}
