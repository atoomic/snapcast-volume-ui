#!/usr/bin/env python
import sys
import telnetlib
import json
import threading
import time

telnet = telnetlib.Telnet('127.0.0.1', 1705)
requestId = 1

def doRequest( j, requestId ):
	print("send: " + j)
	telnet.write(j + "\r\n")
	while (True):
		response = telnet.read_until("\r\n", 2)
		jResponse = json.loads(response)
		if 'id' in jResponse:
			if jResponse['id'] == requestId:
				return jResponse;
	return;

def setVolume(client, volume):
	global requestId
	doRequest(json.dumps({'jsonrpc': '2.0', 'method': 'Client.SetVolume', 'params': {'client':  client, 'volume': volume}, 'id': requestId}), requestId)
	requestId = requestId + 1

volume = int(sys.argv[2])
setVolume(sys.argv[1], volume)

telnet.close
