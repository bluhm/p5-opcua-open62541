# begin generated by script/client-server-read-write.pl

UA_StatusCode
UA_Client_readAccessLevelAttribute(client, nodeId, outByte)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Byte		outByte
    CODE:
	RETVAL = UA_Client_readAccessLevelAttribute(client->cl_client,
	    *nodeId, outByte);
	XS_pack_UA_Byte(SvRV(ST(2)), *outByte);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeAccessLevelAttribute(client, nodeId, newByte)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Byte		newByte
    CODE:
	RETVAL = UA_Client_writeAccessLevelAttribute(client->cl_client,
	    *nodeId, newByte);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readAccessLevelAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readAccessLevelAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadByteCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readBrowseNameAttribute(client, nodeId, outQualifiedName)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_QualifiedName		outQualifiedName
    CODE:
	RETVAL = UA_Client_readBrowseNameAttribute(client->cl_client,
	    *nodeId, outQualifiedName);
	XS_pack_UA_QualifiedName(SvRV(ST(2)), *outQualifiedName);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeBrowseNameAttribute(client, nodeId, newQualifiedName)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_QualifiedName		newQualifiedName
    CODE:
	RETVAL = UA_Client_writeBrowseNameAttribute(client->cl_client,
	    *nodeId, newQualifiedName);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readBrowseNameAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readBrowseNameAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadQualifiedNameCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readContainsNoLoopsAttribute(client, nodeId, outBoolean)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		outBoolean
    CODE:
	RETVAL = UA_Client_readContainsNoLoopsAttribute(client->cl_client,
	    *nodeId, outBoolean);
	XS_pack_UA_Boolean(SvRV(ST(2)), *outBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeContainsNoLoopsAttribute(client, nodeId, newBoolean)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		newBoolean
    CODE:
	RETVAL = UA_Client_writeContainsNoLoopsAttribute(client->cl_client,
	    *nodeId, newBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readContainsNoLoopsAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readContainsNoLoopsAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadBooleanCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readDataTypeAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readDataTypeAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadDataTypeCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readDescriptionAttribute(client, nodeId, outLocalizedText)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_LocalizedText		outLocalizedText
    CODE:
	RETVAL = UA_Client_readDescriptionAttribute(client->cl_client,
	    *nodeId, outLocalizedText);
	XS_pack_UA_LocalizedText(SvRV(ST(2)), *outLocalizedText);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeDescriptionAttribute(client, nodeId, newLocalizedText)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_LocalizedText		newLocalizedText
    CODE:
	RETVAL = UA_Client_writeDescriptionAttribute(client->cl_client,
	    *nodeId, newLocalizedText);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readDescriptionAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readDescriptionAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadLocalizedTextCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readDisplayNameAttribute(client, nodeId, outLocalizedText)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_LocalizedText		outLocalizedText
    CODE:
	RETVAL = UA_Client_readDisplayNameAttribute(client->cl_client,
	    *nodeId, outLocalizedText);
	XS_pack_UA_LocalizedText(SvRV(ST(2)), *outLocalizedText);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeDisplayNameAttribute(client, nodeId, newLocalizedText)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_LocalizedText		newLocalizedText
    CODE:
	RETVAL = UA_Client_writeDisplayNameAttribute(client->cl_client,
	    *nodeId, newLocalizedText);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readDisplayNameAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readDisplayNameAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadLocalizedTextCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readEventNotifierAttribute(client, nodeId, outByte)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Byte		outByte
    CODE:
	RETVAL = UA_Client_readEventNotifierAttribute(client->cl_client,
	    *nodeId, outByte);
	XS_pack_UA_Byte(SvRV(ST(2)), *outByte);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeEventNotifierAttribute(client, nodeId, newByte)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Byte		newByte
    CODE:
	RETVAL = UA_Client_writeEventNotifierAttribute(client->cl_client,
	    *nodeId, newByte);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readEventNotifierAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readEventNotifierAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadByteCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readExecutableAttribute(client, nodeId, outBoolean)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		outBoolean
    CODE:
	RETVAL = UA_Client_readExecutableAttribute(client->cl_client,
	    *nodeId, outBoolean);
	XS_pack_UA_Boolean(SvRV(ST(2)), *outBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeExecutableAttribute(client, nodeId, newBoolean)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		newBoolean
    CODE:
	RETVAL = UA_Client_writeExecutableAttribute(client->cl_client,
	    *nodeId, newBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readExecutableAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readExecutableAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadBooleanCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readHistorizingAttribute(client, nodeId, outBoolean)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		outBoolean
    CODE:
	RETVAL = UA_Client_readHistorizingAttribute(client->cl_client,
	    *nodeId, outBoolean);
	XS_pack_UA_Boolean(SvRV(ST(2)), *outBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeHistorizingAttribute(client, nodeId, newBoolean)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		newBoolean
    CODE:
	RETVAL = UA_Client_writeHistorizingAttribute(client->cl_client,
	    *nodeId, newBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readHistorizingAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readHistorizingAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadBooleanCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readInverseNameAttribute(client, nodeId, outLocalizedText)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_LocalizedText		outLocalizedText
    CODE:
	RETVAL = UA_Client_readInverseNameAttribute(client->cl_client,
	    *nodeId, outLocalizedText);
	XS_pack_UA_LocalizedText(SvRV(ST(2)), *outLocalizedText);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeInverseNameAttribute(client, nodeId, newLocalizedText)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_LocalizedText		newLocalizedText
    CODE:
	RETVAL = UA_Client_writeInverseNameAttribute(client->cl_client,
	    *nodeId, newLocalizedText);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readInverseNameAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readInverseNameAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadLocalizedTextCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readIsAbstractAttribute(client, nodeId, outBoolean)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		outBoolean
    CODE:
	RETVAL = UA_Client_readIsAbstractAttribute(client->cl_client,
	    *nodeId, outBoolean);
	XS_pack_UA_Boolean(SvRV(ST(2)), *outBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeIsAbstractAttribute(client, nodeId, newBoolean)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		newBoolean
    CODE:
	RETVAL = UA_Client_writeIsAbstractAttribute(client->cl_client,
	    *nodeId, newBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readIsAbstractAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readIsAbstractAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadBooleanCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readMinimumSamplingIntervalAttribute(client, nodeId, outDouble)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Double		outDouble
    CODE:
	RETVAL = UA_Client_readMinimumSamplingIntervalAttribute(client->cl_client,
	    *nodeId, outDouble);
	XS_pack_UA_Double(SvRV(ST(2)), *outDouble);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeMinimumSamplingIntervalAttribute(client, nodeId, newDouble)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Double		newDouble
    CODE:
	RETVAL = UA_Client_writeMinimumSamplingIntervalAttribute(client->cl_client,
	    *nodeId, newDouble);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readMinimumSamplingIntervalAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readMinimumSamplingIntervalAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadDoubleCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readNodeClassAttribute(client, nodeId, outNodeClass)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_NodeClass		outNodeClass
    CODE:
	RETVAL = UA_Client_readNodeClassAttribute(client->cl_client,
	    *nodeId, outNodeClass);
	XS_pack_UA_NodeClass(SvRV(ST(2)), *outNodeClass);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeNodeClassAttribute(client, nodeId, newNodeClass)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_NodeClass		newNodeClass
    CODE:
	RETVAL = UA_Client_writeNodeClassAttribute(client->cl_client,
	    *nodeId, newNodeClass);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readNodeClassAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readNodeClassAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadNodeClassCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readNodeIdAttribute(client, nodeId, outNodeId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_NodeId		outNodeId
    CODE:
	RETVAL = UA_Client_readNodeIdAttribute(client->cl_client,
	    *nodeId, outNodeId);
	XS_pack_UA_NodeId(SvRV(ST(2)), *outNodeId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeNodeIdAttribute(client, nodeId, newNodeId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_NodeId		newNodeId
    CODE:
	RETVAL = UA_Client_writeNodeIdAttribute(client->cl_client,
	    *nodeId, newNodeId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readSymmetricAttribute(client, nodeId, outBoolean)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		outBoolean
    CODE:
	RETVAL = UA_Client_readSymmetricAttribute(client->cl_client,
	    *nodeId, outBoolean);
	XS_pack_UA_Boolean(SvRV(ST(2)), *outBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeSymmetricAttribute(client, nodeId, newBoolean)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		newBoolean
    CODE:
	RETVAL = UA_Client_writeSymmetricAttribute(client->cl_client,
	    *nodeId, newBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readSymmetricAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readSymmetricAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadBooleanCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readUserAccessLevelAttribute(client, nodeId, outByte)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Byte		outByte
    CODE:
	RETVAL = UA_Client_readUserAccessLevelAttribute(client->cl_client,
	    *nodeId, outByte);
	XS_pack_UA_Byte(SvRV(ST(2)), *outByte);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeUserAccessLevelAttribute(client, nodeId, newByte)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Byte		newByte
    CODE:
	RETVAL = UA_Client_writeUserAccessLevelAttribute(client->cl_client,
	    *nodeId, newByte);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readUserAccessLevelAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readUserAccessLevelAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadByteCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readUserExecutableAttribute(client, nodeId, outBoolean)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		outBoolean
    CODE:
	RETVAL = UA_Client_readUserExecutableAttribute(client->cl_client,
	    *nodeId, outBoolean);
	XS_pack_UA_Boolean(SvRV(ST(2)), *outBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeUserExecutableAttribute(client, nodeId, newBoolean)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Boolean		newBoolean
    CODE:
	RETVAL = UA_Client_writeUserExecutableAttribute(client->cl_client,
	    *nodeId, newBoolean);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readUserExecutableAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readUserExecutableAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadBooleanCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readUserWriteMaskAttribute(client, nodeId, outUInt32)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_UInt32		outUInt32
    CODE:
	RETVAL = UA_Client_readUserWriteMaskAttribute(client->cl_client,
	    *nodeId, outUInt32);
	XS_pack_UA_UInt32(SvRV(ST(2)), *outUInt32);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeUserWriteMaskAttribute(client, nodeId, newUInt32)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_UInt32		newUInt32
    CODE:
	RETVAL = UA_Client_writeUserWriteMaskAttribute(client->cl_client,
	    *nodeId, newUInt32);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readUserWriteMaskAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readUserWriteMaskAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadUInt32Callback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

#ifdef HAVE_UA_CLIENTASYNCREADVALUEATTRIBUTECALLBACK_DATAVALUE

UA_StatusCode
UA_Client_readValueAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readValueAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadDataValueCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

#endif

UA_StatusCode
UA_Client_readValueAttribute(client, nodeId, outVariant)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Variant		outVariant
    CODE:
	RETVAL = UA_Client_readValueAttribute(client->cl_client,
	    *nodeId, outVariant);
	XS_pack_UA_Variant(SvRV(ST(2)), *outVariant);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeValueAttribute(client, nodeId, newVariant)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Variant		newVariant
    CODE:
	RETVAL = UA_Client_writeValueAttribute(client->cl_client,
	    *nodeId, newVariant);
    OUTPUT:
	RETVAL

#ifdef HAVE_UA_CLIENTASYNCREADVALUEATTRIBUTECALLBACK_VARIANT

UA_StatusCode
UA_Client_readValueAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readValueAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadVariantCallback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

#endif

UA_StatusCode
UA_Client_readValueRankAttribute(client, nodeId, outInt32)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Int32		outInt32
    CODE:
	RETVAL = UA_Client_readValueRankAttribute(client->cl_client,
	    *nodeId, outInt32);
	XS_pack_UA_Int32(SvRV(ST(2)), *outInt32);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeValueRankAttribute(client, nodeId, newInt32)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_Int32		newInt32
    CODE:
	RETVAL = UA_Client_writeValueRankAttribute(client->cl_client,
	    *nodeId, newInt32);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readValueRankAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readValueRankAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadInt32Callback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readWriteMaskAttribute(client, nodeId, outUInt32)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_UInt32		outUInt32
    CODE:
	RETVAL = UA_Client_readWriteMaskAttribute(client->cl_client,
	    *nodeId, outUInt32);
	XS_pack_UA_UInt32(SvRV(ST(2)), *outUInt32);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_writeWriteMaskAttribute(client, nodeId, newUInt32)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	OPCUA_Open62541_UInt32		newUInt32
    CODE:
	RETVAL = UA_Client_writeWriteMaskAttribute(client->cl_client,
	    *nodeId, newUInt32);
    OUTPUT:
	RETVAL

UA_StatusCode
UA_Client_readWriteMaskAttribute_async(client, nodeId, callback, data, outoptReqId)
	OPCUA_Open62541_Client		client
	OPCUA_Open62541_NodeId		nodeId
	SV *				callback
	SV *				data
	OPCUA_Open62541_UInt32		outoptReqId
    PREINIT:
	ClientCallbackData		ccd;
    CODE:
	ccd = newClientCallbackData(callback, ST(0), data);
	RETVAL = UA_Client_readWriteMaskAttribute_async(client->cl_client,
	    *nodeId, clientAsyncReadUInt32Callback, ccd, outoptReqId);
	if (RETVAL != UA_STATUSCODE_GOOD)
		deleteClientCallbackData(ccd);
	if (outoptReqId != NULL)
		XS_pack_UA_UInt32(SvRV(ST(4)), *outoptReqId);
    OUTPUT:
	RETVAL

# end generated by script/client-server-read-write.pl
