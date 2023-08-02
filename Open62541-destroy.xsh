# begin generated by script/destroy.pl

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::ApplicationDescription	PREFIX = UA_ApplicationDescription_

void
UA_ApplicationDescription_DESTROY(applicationDescription)
	OPCUA_Open62541_ApplicationDescription	applicationDescription
    CODE:
	DPRINTF("applicationDescription %p", applicationDescription);
	UA_ApplicationDescription_delete(applicationDescription);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::Boolean	PREFIX = UA_Boolean_

void
UA_Boolean_DESTROY(boolean)
	OPCUA_Open62541_Boolean	boolean
    CODE:
	DPRINTF("boolean %p", boolean);
	UA_Boolean_delete(boolean);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::BrowseDescription	PREFIX = UA_BrowseDescription_

void
UA_BrowseDescription_DESTROY(browseDescription)
	OPCUA_Open62541_BrowseDescription	browseDescription
    CODE:
	DPRINTF("browseDescription %p", browseDescription);
	UA_BrowseDescription_delete(browseDescription);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::BrowseNextRequest	PREFIX = UA_BrowseNextRequest_

void
UA_BrowseNextRequest_DESTROY(browseNextRequest)
	OPCUA_Open62541_BrowseNextRequest	browseNextRequest
    CODE:
	DPRINTF("browseNextRequest %p", browseNextRequest);
	UA_BrowseNextRequest_delete(browseNextRequest);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::BrowseRequest	PREFIX = UA_BrowseRequest_

void
UA_BrowseRequest_DESTROY(browseRequest)
	OPCUA_Open62541_BrowseRequest	browseRequest
    CODE:
	DPRINTF("browseRequest %p", browseRequest);
	UA_BrowseRequest_delete(browseRequest);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::BuildInfo	PREFIX = UA_BuildInfo_

void
UA_BuildInfo_DESTROY(buildInfo)
	OPCUA_Open62541_BuildInfo	buildInfo
    CODE:
	DPRINTF("buildInfo %p", buildInfo);
	UA_BuildInfo_delete(buildInfo);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::Byte	PREFIX = UA_Byte_

void
UA_Byte_DESTROY(byte)
	OPCUA_Open62541_Byte	byte
    CODE:
	DPRINTF("byte %p", byte);
	UA_Byte_delete(byte);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::ByteString	PREFIX = UA_ByteString_

void
UA_ByteString_DESTROY(byteString)
	OPCUA_Open62541_ByteString	byteString
    CODE:
	DPRINTF("byteString %p", byteString);
	UA_ByteString_delete(byteString);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::CertificateVerification	PREFIX = UA_CertificateVerification_

void
UA_CertificateVerification_DESTROY(certificateVerification)
	OPCUA_Open62541_CertificateVerification	certificateVerification
    CODE:
	DPRINTF("certificateVerification %p", certificateVerification);
	UA_CertificateVerification_delete(certificateVerification);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::CreateMonitoredItemsRequest	PREFIX = UA_CreateMonitoredItemsRequest_

void
UA_CreateMonitoredItemsRequest_DESTROY(createMonitoredItemsRequest)
	OPCUA_Open62541_CreateMonitoredItemsRequest	createMonitoredItemsRequest
    CODE:
	DPRINTF("createMonitoredItemsRequest %p", createMonitoredItemsRequest);
	UA_CreateMonitoredItemsRequest_delete(createMonitoredItemsRequest);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::CreateSubscriptionRequest	PREFIX = UA_CreateSubscriptionRequest_

void
UA_CreateSubscriptionRequest_DESTROY(createSubscriptionRequest)
	OPCUA_Open62541_CreateSubscriptionRequest	createSubscriptionRequest
    CODE:
	DPRINTF("createSubscriptionRequest %p", createSubscriptionRequest);
	UA_CreateSubscriptionRequest_delete(createSubscriptionRequest);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::DataTypeAttributes	PREFIX = UA_DataTypeAttributes_

void
UA_DataTypeAttributes_DESTROY(dataTypeAttributes)
	OPCUA_Open62541_DataTypeAttributes	dataTypeAttributes
    CODE:
	DPRINTF("dataTypeAttributes %p", dataTypeAttributes);
	UA_DataTypeAttributes_delete(dataTypeAttributes);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::DeleteMonitoredItemsRequest	PREFIX = UA_DeleteMonitoredItemsRequest_

void
UA_DeleteMonitoredItemsRequest_DESTROY(deleteMonitoredItemsRequest)
	OPCUA_Open62541_DeleteMonitoredItemsRequest	deleteMonitoredItemsRequest
    CODE:
	DPRINTF("deleteMonitoredItemsRequest %p", deleteMonitoredItemsRequest);
	UA_DeleteMonitoredItemsRequest_delete(deleteMonitoredItemsRequest);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::DeleteSubscriptionsRequest	PREFIX = UA_DeleteSubscriptionsRequest_

void
UA_DeleteSubscriptionsRequest_DESTROY(deleteSubscriptionsRequest)
	OPCUA_Open62541_DeleteSubscriptionsRequest	deleteSubscriptionsRequest
    CODE:
	DPRINTF("deleteSubscriptionsRequest %p", deleteSubscriptionsRequest);
	UA_DeleteSubscriptionsRequest_delete(deleteSubscriptionsRequest);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::Double	PREFIX = UA_Double_

void
UA_Double_DESTROY(double_)
	OPCUA_Open62541_Double	double_
    CODE:
	DPRINTF("double_ %p", double_);
	UA_Double_delete(double_);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::ExpandedNodeId	PREFIX = UA_ExpandedNodeId_

void
UA_ExpandedNodeId_DESTROY(expandedNodeId)
	OPCUA_Open62541_ExpandedNodeId	expandedNodeId
    CODE:
	DPRINTF("expandedNodeId %p", expandedNodeId);
	UA_ExpandedNodeId_delete(expandedNodeId);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::Int32	PREFIX = UA_Int32_

void
UA_Int32_DESTROY(int32)
	OPCUA_Open62541_Int32	int32
    CODE:
	DPRINTF("int32 %p", int32);
	UA_Int32_delete(int32);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::LocalizedText	PREFIX = UA_LocalizedText_

void
UA_LocalizedText_DESTROY(localizedText)
	OPCUA_Open62541_LocalizedText	localizedText
    CODE:
	DPRINTF("localizedText %p", localizedText);
	UA_LocalizedText_delete(localizedText);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::MessageSecurityMode	PREFIX = UA_MessageSecurityMode_

void
UA_MessageSecurityMode_DESTROY(messageSecurityMode)
	OPCUA_Open62541_MessageSecurityMode	messageSecurityMode
    CODE:
	DPRINTF("messageSecurityMode %p", messageSecurityMode);
	UA_MessageSecurityMode_delete(messageSecurityMode);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::ModifySubscriptionRequest	PREFIX = UA_ModifySubscriptionRequest_

void
UA_ModifySubscriptionRequest_DESTROY(modifySubscriptionRequest)
	OPCUA_Open62541_ModifySubscriptionRequest	modifySubscriptionRequest
    CODE:
	DPRINTF("modifySubscriptionRequest %p", modifySubscriptionRequest);
	UA_ModifySubscriptionRequest_delete(modifySubscriptionRequest);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::MonitoredItemCreateRequest	PREFIX = UA_MonitoredItemCreateRequest_

void
UA_MonitoredItemCreateRequest_DESTROY(monitoredItemCreateRequest)
	OPCUA_Open62541_MonitoredItemCreateRequest	monitoredItemCreateRequest
    CODE:
	DPRINTF("monitoredItemCreateRequest %p", monitoredItemCreateRequest);
	UA_MonitoredItemCreateRequest_delete(monitoredItemCreateRequest);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::NodeClass	PREFIX = UA_NodeClass_

void
UA_NodeClass_DESTROY(nodeClass)
	OPCUA_Open62541_NodeClass	nodeClass
    CODE:
	DPRINTF("nodeClass %p", nodeClass);
	UA_NodeClass_delete(nodeClass);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::NodeId	PREFIX = UA_NodeId_

void
UA_NodeId_DESTROY(nodeId)
	OPCUA_Open62541_NodeId	nodeId
    CODE:
	DPRINTF("nodeId %p", nodeId);
	UA_NodeId_delete(nodeId);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::ObjectAttributes	PREFIX = UA_ObjectAttributes_

void
UA_ObjectAttributes_DESTROY(objectAttributes)
	OPCUA_Open62541_ObjectAttributes	objectAttributes
    CODE:
	DPRINTF("objectAttributes %p", objectAttributes);
	UA_ObjectAttributes_delete(objectAttributes);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::ObjectTypeAttributes	PREFIX = UA_ObjectTypeAttributes_

void
UA_ObjectTypeAttributes_DESTROY(objectTypeAttributes)
	OPCUA_Open62541_ObjectTypeAttributes	objectTypeAttributes
    CODE:
	DPRINTF("objectTypeAttributes %p", objectTypeAttributes);
	UA_ObjectTypeAttributes_delete(objectTypeAttributes);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::QualifiedName	PREFIX = UA_QualifiedName_

void
UA_QualifiedName_DESTROY(qualifiedName)
	OPCUA_Open62541_QualifiedName	qualifiedName
    CODE:
	DPRINTF("qualifiedName %p", qualifiedName);
	UA_QualifiedName_delete(qualifiedName);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::ReadRequest	PREFIX = UA_ReadRequest_

void
UA_ReadRequest_DESTROY(readRequest)
	OPCUA_Open62541_ReadRequest	readRequest
    CODE:
	DPRINTF("readRequest %p", readRequest);
	UA_ReadRequest_delete(readRequest);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::ReadValueId	PREFIX = UA_ReadValueId_

void
UA_ReadValueId_DESTROY(readValueId)
	OPCUA_Open62541_ReadValueId	readValueId
    CODE:
	DPRINTF("readValueId %p", readValueId);
	UA_ReadValueId_delete(readValueId);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::ReferenceTypeAttributes	PREFIX = UA_ReferenceTypeAttributes_

void
UA_ReferenceTypeAttributes_DESTROY(referenceTypeAttributes)
	OPCUA_Open62541_ReferenceTypeAttributes	referenceTypeAttributes
    CODE:
	DPRINTF("referenceTypeAttributes %p", referenceTypeAttributes);
	UA_ReferenceTypeAttributes_delete(referenceTypeAttributes);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::SetPublishingModeRequest	PREFIX = UA_SetPublishingModeRequest_

void
UA_SetPublishingModeRequest_DESTROY(setPublishingModeRequest)
	OPCUA_Open62541_SetPublishingModeRequest	setPublishingModeRequest
    CODE:
	DPRINTF("setPublishingModeRequest %p", setPublishingModeRequest);
	UA_SetPublishingModeRequest_delete(setPublishingModeRequest);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::UInt32	PREFIX = UA_UInt32_

void
UA_UInt32_DESTROY(uInt32)
	OPCUA_Open62541_UInt32	uInt32
    CODE:
	DPRINTF("uInt32 %p", uInt32);
	UA_UInt32_delete(uInt32);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::VariableAttributes	PREFIX = UA_VariableAttributes_

void
UA_VariableAttributes_DESTROY(variableAttributes)
	OPCUA_Open62541_VariableAttributes	variableAttributes
    CODE:
	DPRINTF("variableAttributes %p", variableAttributes);
	UA_VariableAttributes_delete(variableAttributes);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::VariableTypeAttributes	PREFIX = UA_VariableTypeAttributes_

void
UA_VariableTypeAttributes_DESTROY(variableTypeAttributes)
	OPCUA_Open62541_VariableTypeAttributes	variableTypeAttributes
    CODE:
	DPRINTF("variableTypeAttributes %p", variableTypeAttributes);
	UA_VariableTypeAttributes_delete(variableTypeAttributes);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::Variant	PREFIX = UA_Variant_

void
UA_Variant_DESTROY(variant)
	OPCUA_Open62541_Variant	variant
    CODE:
	DPRINTF("variant %p", variant);
	UA_Variant_delete(variant);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::ViewAttributes	PREFIX = UA_ViewAttributes_

void
UA_ViewAttributes_DESTROY(viewAttributes)
	OPCUA_Open62541_ViewAttributes	viewAttributes
    CODE:
	DPRINTF("viewAttributes %p", viewAttributes);
	UA_ViewAttributes_delete(viewAttributes);

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::WriteValue	PREFIX = UA_WriteValue_

void
UA_WriteValue_DESTROY(writeValue)
	OPCUA_Open62541_WriteValue	writeValue
    CODE:
	DPRINTF("writeValue %p", writeValue);
	UA_WriteValue_delete(writeValue);

# end generated by script/destroy.pl
