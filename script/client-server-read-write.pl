#!/usr/bin/perl
# Generate client/server read/write XS wrapper, async functions and callback.

use strict;
use warnings;

# name type
# client-read client-write client-async client-callback
# server-read server-write
my @funcs = (
  [qw(	Value			Variant		1 1 0 0		1 1	)],
  [qw(	Value			Variant		0 0 1 1		0 0
	HAVE_UA_CLIENTASYNCREADVALUEATTRIBUTECALLBACK_VARIANT)],
  [qw(	Value			DataValue	0 0 1 1		0 0
	HAVE_UA_CLIENTASYNCREADVALUEATTRIBUTECALLBACK_DATAVALUE)],
  [qw(	DataType		DataType	0 0 1 0		0 0	)],
  [qw(	NodeId			NodeId		1 1 0 0		1 0	)],
  [qw(	NodeClass		NodeClass	1 1 1 1		1 0	)],
  [qw(	BrowseName		QualifiedName	1 1 1 1		1 1	)],
  [qw(	DisplayName		LocalizedText	1 1 1 1		1 1	)],
  [qw(	Description		LocalizedText	1 1 1 1		1 1	)],
  [qw(	WriteMask		UInt32		1 1 1 1		1 1	)],
  [qw(	UserWriteMask		UInt32		1 1 1 1		0 0	)],
  [qw(	IsAbstract		Boolean		1 1 1 1		1 1	)],
  [qw(	Symmetric		Boolean		1 1 1 1		1 0	)],
  [qw(	InverseName		LocalizedText	1 1 1 1		1 1	)],
  [qw(	ContainsNoLoops		Boolean		1 1 1 1		1 0	)],
  [qw(	EventNotifier		Byte		1 1 1 1		1 1	)],
  [qw(	ValueRank		Int32		1 1 1 1		1 1	)],
  [qw(	ArrayDimensions		Variant		0 0 0 0		1 1	)],
  [qw(	AccessLevel		Byte		1 1 1 1		1 1	)],
  [qw(	UserAccessLevel		Byte		1 1 1 1		0 0	)],
  [qw(	MinimumSamplingInterval	Double		1 1 1 1		1 1	)],
  [qw(	Historizing		Boolean		1 1 1 1		1 1	)],
  [qw(	Executable		Boolean		1 1 1 1		1 1	)],
  [qw(	UserExecutable		Boolean		1 1 1 1		0 0	)],
  [qw(	ObjectProperty		Variant		0 0 0 0		0 0	)],
);

open(my $cf, '>', "Open62541-client-read-callback.xsh")
    or die "Open 'Open62541-client-read-callback.xsh' for writing failed: $!";
print $cf "/* begin generated by $0 */\n\n";
open(my $crwf, '>', "Open62541-client-read-write.xsh")
    or die "Open 'Open62541-client-read-write.xsh' for writing failed: $!";
print $crwf "# begin generated by $0\n\n";
open(my $srwf, '>', "Open62541-server-read-write.xsh")
    or die "Open 'Open62541-server-read-write.xsh' for writing failed: $!";
print $srwf "# begin generated by $0\n\n";

my (%names, %types, $count);
foreach (@funcs) {
    my ($name, $type, $cr, $cw, $ca, $cc, $sr, $sw, $ifdef) = @$_;
    $names{$name,$type,++$count} = $_;
    for (my $i = 0; $i < @$_; $i++) {
	$types{$type}->[$i] ||= $_->[$i];
    }
}
foreach my $k (sort keys %names) {
    my ($name, $type, $cr, $cw, $ca, $cc, $sr, $sw, $ifdef) = @{$names{$k}};
    print $crwf "#ifdef $ifdef\n\n" if $ifdef;
    print_xs_client_read($crwf, $name, $type) if $cr;
    print_xs_client_write($crwf, $name, $type) if $cw;
    print_xs_client_async($crwf, $name, $type) if $ca;
    print $crwf "#endif\n\n" if $ifdef;
    print_xs_server_read($srwf, $name, $type) if $sr;
    print_xs_server_write($srwf, $name, $type) if $sw;
}
foreach my $type (sort keys %types) {
    my (undef, undef, $cr, $cw, $ca, $cc, $sr, $sw, $ifdef) = @{$types{$type}};
    print $cf "#ifdef $ifdef\n\n" if $ifdef;
    print_xs_client_callback($cf, $type) if $cc;
    print $cf "#endif\n\n" if $ifdef;
}

print $cf "/* end generated by $0 */\n";
close($cf) or die
    "Close 'Open62541-client-read-callback.xsh' after writing failed: $!";
print $crwf "# end generated by $0\n";
close($crwf) or die
    "Close 'Open62541-client-read-write.xsh' after writing failed: $!";
print $srwf "# end generated by $0\n";
close($srwf) or die
    "Close 'Open62541-server-read-write.xsh' after writing failed: $!";

exit(0);

########################################################################
sub print_xs_client_read {
    my ($xsf, $name, $type) = @_;
    my $func = "${name}Attribute";
    print $xsf <<"EOXSFUNC";
UA_StatusCode
UA_Client_read${func}(client, nodeId, out${type})
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_${type}		out${type}
    CODE:
	RETVAL = UA_Client_read${func}(client->cl_client,
	    *nodeId, out${type});
	XS_pack_UA_${type}(SvRV(ST(2)), *out${type});
    OUTPUT:
	RETVAL

EOXSFUNC
}

########################################################################
sub print_xs_client_write {
    my ($xsf, $name, $type) = @_;
    my $func= "${name}Attribute";
    print $xsf <<"EOXSFUNC";
UA_StatusCode
UA_Client_write${func}(client, nodeId, new${type})
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_${type}		new${type}
    CODE:
	RETVAL = UA_Client_write${func}(client->cl_client,
	    *nodeId, new${type});
    OUTPUT:
	RETVAL

EOXSFUNC
}

########################################################################
sub print_xs_client_async {
    my ($xsf, $name, $type) = @_;
    my $func = "${name}Attribute";
    print $xsf <<"EOXSFUNC";
UA_StatusCode
UA_Client_read${func}_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_read${func}_async(client->cl_client,
	    *nodeId, clientAsyncRead${type}Callback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

EOXSFUNC
}

########################################################################
sub print_xs_client_callback {
    my ($xsf, $type) = @_;
    print $xsf <<"EOXSFUNC";
static void
clientAsyncRead${type}Callback(UA_Client *client, void *userdata,
    UA_UInt32 requestId, UA_StatusCode status, UA_${type} *var)
{
	dTHX;
	SV *sv;

	sv = newSV(0);
	if (var != NULL)
		XS_pack_UA_${type}(sv, *var);

	/* XXX we do not propagate the status code */
	clientCallbackPerl(client, userdata, requestId, sv);
}

EOXSFUNC
}

########################################################################
sub print_xs_server_read {
    my ($xsf, $name, $type) = @_;
    print $xsf <<"EOXSFUNC";
UA_StatusCode
UA_Server_read${name}(server, nodeId, out${type})
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_${type}		out${type}
    CODE:
	RETVAL = UA_Server_read${name}(server->sv_server,
	    *nodeId, out${type});
	XS_pack_UA_${type}(SvRV(ST(2)), *out${type});
    OUTPUT:
	RETVAL

EOXSFUNC
}

########################################################################
sub print_xs_server_write {
    my ($xsf, $name, $type) = @_;
    print $xsf <<"EOXSFUNC";
UA_StatusCode
UA_Server_write${name}(server, nodeId, new${type})
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_${type}		new${type}
    CODE:
	RETVAL = UA_Server_write${name}(server->sv_server,
	    *nodeId, *new${type});
    OUTPUT:
	RETVAL

EOXSFUNC
}
