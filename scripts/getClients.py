#!/usr/bin/env python
import sys
import telnetlib
import json
import threading
import time
import json

telnet = telnetlib.Telnet('127.0.0.1', 1705)
requestId = 1

def doRequest( j, requestId ):
    telnet.write(j + "\r\n")
    while (True):
        response = telnet.read_until("\r\n", 2)
        jResponse = json.loads(response)
        if 'id' in jResponse:
            if jResponse['id'] == requestId:
                return jResponse;
    return;

j = doRequest(json.dumps({'jsonrpc': '2.0', 'method': 'Server.GetStatus', 'id': 1}), 1)
print(json.dumps(j["result"]["clients"]))

telnet.close