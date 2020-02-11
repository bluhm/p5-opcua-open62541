#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <open62541/types.h>
#include <open62541/statuscodes.h>
#include <open62541/server.h>
#include <open62541/server_config_default.h>

/* #define DEBUG */
#ifdef DEBUG
# define DPRINTF(format, args...)					\
	do {								\
		fprintf(stderr, "%s: " format "\n", __func__, ##args);	\
	} while (0)
#else
# define DPRINTF(format, x...)
#endif

typedef UA_StatusCode		OPCUA_Open62541_StatusCode;
typedef UA_Server *		OPCUA_Open62541_Server;
typedef UA_ServerConfig *	OPCUA_Open62541_ServerConfig;

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541

PROTOTYPES: DISABLE

INCLUDE: Open62541-statuscodes.xsh

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::Server		PREFIX = UA_Server_

OPCUA_Open62541_Server
UA_Server_new(class)
	char *				class
    INIT:
	if (strcmp(class, "OPCUA::Open62541::Server") != 0)
		croak("class '%s' is not OPCUA::Open62541::Server", class);
    CODE:
	RETVAL = UA_Server_new();
	DPRINTF("class %s, server %p", class, RETVAL);
    OUTPUT:
	RETVAL

OPCUA_Open62541_Server
UA_Server_newWithConfig(class, config)
	char *				class
	OPCUA_Open62541_ServerConfig	config
    INIT:
	if (strcmp(class, "OPCUA::Open62541::Server") != 0)
		croak("class '%s' is not OPCUA::Open62541::Server", class);
    CODE:
	RETVAL = UA_Server_newWithConfig(config);
	DPRINTF("class %s, config %p, server %p", class, config, RETVAL);
    OUTPUT:
	RETVAL

void
UA_Server_DESTROY(server)
	OPCUA_Open62541_Server		server
    CODE:
	DPRINTF("server %p", server);
	UA_Server_delete(server);

OPCUA_Open62541_ServerConfig
UA_Server_getConfig(server)
	OPCUA_Open62541_Server		server
    CODE:
	RETVAL = UA_Server_getConfig(server);
	/* XXX when server is freed, config gets invalid */
	DPRINTF("server %p, config %p", server, RETVAL);
    OUTPUT:
	RETVAL

MODULE = OPCUA::Open62541	PACKAGE = OPCUA::Open62541::ServerConfig	PREFIX = UA_ServerConfig_

OPCUA_Open62541_StatusCode
UA_ServerConfig_setDefault(config)
	OPCUA_Open62541_ServerConfig	config
