# begin generated by script/client-server-read-write.pl

UA_StatusCode
UA_Server_readAccessLevel(server, nodeId, outByte)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Byte		outByte
    CODE:
	RETVAL = UA_Server_readAccessLevel(server->sv_server,
	    *nodeId, outByte);
	XS_pack_UA_Byte(SvRV(ST(2)), *outByte);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_writeAccessLevel(server, nodeId, newByte)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Byte		newByte
    CODE:
	RETVAL = UA_Server_writeAccessLevel(server->sv_server,
	    *nodeId, *newByte);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_readArrayDimensions(server, nodeId, outVariant)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Variant		outVariant
    CODE:
	RETVAL = UA_Server_readArrayDimensions(server->sv_server,
	    *nodeId, outVariant);
	XS_pack_UA_Variant(SvRV(ST(2)), *outVariant);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_writeArrayDimensions(server, nodeId, newVariant)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Variant		newVariant
    CODE:
	RETVAL = UA_Server_writeArrayDimensions(server->sv_server,
	    *nodeId, *newVariant);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_readBrowseName(server, nodeId, outQualifiedName)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_QualifiedName		outQualifiedName
    CODE:
	RETVAL = UA_Server_readBrowseName(server->sv_server,
	    *nodeId, outQualifiedName);
	XS_pack_UA_QualifiedName(SvRV(ST(2)), *outQualifiedName);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_writeBrowseName(server, nodeId, newQualifiedName)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_QualifiedName		newQualifiedName
    CODE:
	RETVAL = UA_Server_writeBrowseName(server->sv_server,
	    *nodeId, *newQualifiedName);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_readContainsNoLoop(server, nodeId, outBoolean)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		outBoolean
    CODE:
	RETVAL = UA_Server_readContainsNoLoop(server->sv_server,
	    *nodeId, outBoolean);
	XS_pack_UA_Boolean(SvRV(ST(2)), *outBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_readDescription(server, nodeId, outLocalizedText)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_LocalizedText		outLocalizedText
    CODE:
	RETVAL = UA_Server_readDescription(server->sv_server,
	    *nodeId, outLocalizedText);
	XS_pack_UA_LocalizedText(SvRV(ST(2)), *outLocalizedText);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_writeDescription(server, nodeId, newLocalizedText)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_LocalizedText		newLocalizedText
    CODE:
	RETVAL = UA_Server_writeDescription(server->sv_server,
	    *nodeId, *newLocalizedText);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_readDisplayName(server, nodeId, outLocalizedText)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_LocalizedText		outLocalizedText
    CODE:
	RETVAL = UA_Server_readDisplayName(server->sv_server,
	    *nodeId, outLocalizedText);
	XS_pack_UA_LocalizedText(SvRV(ST(2)), *outLocalizedText);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_writeDisplayName(server, nodeId, newLocalizedText)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_LocalizedText		newLocalizedText
    CODE:
	RETVAL = UA_Server_writeDisplayName(server->sv_server,
	    *nodeId, *newLocalizedText);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_readEventNotifier(server, nodeId, outByte)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Byte		outByte
    CODE:
	RETVAL = UA_Server_readEventNotifier(server->sv_server,
	    *nodeId, outByte);
	XS_pack_UA_Byte(SvRV(ST(2)), *outByte);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_writeEventNotifier(server, nodeId, newByte)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Byte		newByte
    CODE:
	RETVAL = UA_Server_writeEventNotifier(server->sv_server,
	    *nodeId, *newByte);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_readExecutable(server, nodeId, outBoolean)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		outBoolean
    CODE:
	RETVAL = UA_Server_readExecutable(server->sv_server,
	    *nodeId, outBoolean);
	XS_pack_UA_Boolean(SvRV(ST(2)), *outBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_writeExecutable(server, nodeId, newBoolean)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		newBoolean
    CODE:
	RETVAL = UA_Server_writeExecutable(server->sv_server,
	    *nodeId, *newBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_readHistorizing(server, nodeId, outBoolean)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		outBoolean
    CODE:
	RETVAL = UA_Server_readHistorizing(server->sv_server,
	    *nodeId, outBoolean);
	XS_pack_UA_Boolean(SvRV(ST(2)), *outBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_writeHistorizing(server, nodeId, newBoolean)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		newBoolean
    CODE:
	RETVAL = UA_Server_writeHistorizing(server->sv_server,
	    *nodeId, *newBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_readInverseName(server, nodeId, outLocalizedText)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_LocalizedText		outLocalizedText
    CODE:
	RETVAL = UA_Server_readInverseName(server->sv_server,
	    *nodeId, outLocalizedText);
	XS_pack_UA_LocalizedText(SvRV(ST(2)), *outLocalizedText);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_writeInverseName(server, nodeId, newLocalizedText)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_LocalizedText		newLocalizedText
    CODE:
	RETVAL = UA_Server_writeInverseName(server->sv_server,
	    *nodeId, *newLocalizedText);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_readIsAbstract(server, nodeId, outBoolean)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		outBoolean
    CODE:
	RETVAL = UA_Server_readIsAbstract(server->sv_server,
	    *nodeId, outBoolean);
	XS_pack_UA_Boolean(SvRV(ST(2)), *outBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_writeIsAbstract(server, nodeId, newBoolean)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		newBoolean
    CODE:
	RETVAL = UA_Server_writeIsAbstract(server->sv_server,
	    *nodeId, *newBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_readMinimumSamplingInterval(server, nodeId, outDouble)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Double		outDouble
    CODE:
	RETVAL = UA_Server_readMinimumSamplingInterval(server->sv_server,
	    *nodeId, outDouble);
	XS_pack_UA_Double(SvRV(ST(2)), *outDouble);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_writeMinimumSamplingInterval(server, nodeId, newDouble)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Double		newDouble
    CODE:
	RETVAL = UA_Server_writeMinimumSamplingInterval(server->sv_server,
	    *nodeId, *newDouble);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_readNodeClass(server, nodeId, outNodeClass)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_NodeClass		outNodeClass
    CODE:
	RETVAL = UA_Server_readNodeClass(server->sv_server,
	    *nodeId, outNodeClass);
	XS_pack_UA_NodeClass(SvRV(ST(2)), *outNodeClass);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_readNodeId(server, nodeId, outNodeId)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_NodeId		outNodeId
    CODE:
	RETVAL = UA_Server_readNodeId(server->sv_server,
	    *nodeId, outNodeId);
	XS_pack_UA_NodeId(SvRV(ST(2)), *outNodeId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_readSymmetric(server, nodeId, outBoolean)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		outBoolean
    CODE:
	RETVAL = UA_Server_readSymmetric(server->sv_server,
	    *nodeId, outBoolean);
	XS_pack_UA_Boolean(SvRV(ST(2)), *outBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_readValue(server, nodeId, outVariant)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Variant		outVariant
    CODE:
	RETVAL = UA_Server_readValue(server->sv_server,
	    *nodeId, outVariant);
	XS_pack_UA_Variant(SvRV(ST(2)), *outVariant);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_writeValue(server, nodeId, newVariant)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Variant		newVariant
    CODE:
	RETVAL = UA_Server_writeValue(server->sv_server,
	    *nodeId, *newVariant);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_readValueRank(server, nodeId, outInt32)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Int32		outInt32
    CODE:
	RETVAL = UA_Server_readValueRank(server->sv_server,
	    *nodeId, outInt32);
	XS_pack_UA_Int32(SvRV(ST(2)), *outInt32);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_writeValueRank(server, nodeId, newInt32)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Int32		newInt32
    CODE:
	RETVAL = UA_Server_writeValueRank(server->sv_server,
	    *nodeId, *newInt32);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_readWriteMask(server, nodeId, outUInt32)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_UInt32		outUInt32
    CODE:
	RETVAL = UA_Server_readWriteMask(server->sv_server,
	    *nodeId, outUInt32);
	XS_pack_UA_UInt32(SvRV(ST(2)), *outUInt32);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Server_writeWriteMask(server, nodeId, newUInt32)
	OPCUA_Open62541_Server		server
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_UInt32		newUInt32
    CODE:
	RETVAL = UA_Server_writeWriteMask(server->sv_server,
	    *nodeId, *newUInt32);
    OUTPUT:
	RETVAL

# end generated by script/client-server-read-write.pl
