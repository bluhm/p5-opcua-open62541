#!/usr/bin/perl -n

use strict;
use warnings;

/#define\s+UA_STATUSCODE_(\S+)\s+/
    or next;
print <<"XSINC"
OPCUA_Open62541_StatusCode
STATUSCODE_$1()
    CODE:
        RETVAL = UA_STATUSCODE_$1;
    OUTPUT:
        RETVAL

XSINC
