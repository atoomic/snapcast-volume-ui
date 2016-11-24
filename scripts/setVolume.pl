#!/usr/bin/env perl

my $snapserver = q{mezza.pi.eboxr.com};
my $port       = 1705;

my $client = q{b8:27:eb:27:f6:c4};
my $volume = 100;

my $req = {'jsonrpc' => '2.0', 'method' => 'Client.SetVolume', 
	'params' => {'client' =>  $client, 'volume' => $volume}, 
	'id' => 1 # request id
};

use JSON::XS;
use Net::Telnet;
use Data::Dumper;

my $json = JSON::XS->new->utf8->encode( $req );

$t = Net::Telnet->new(Timeout => 10, Prompt => "/\n/" );
$t->open(Host => $snapserver, Port => $port) or die;

my ($reply) = $t->cmd($json . "\r\n");

my $results = JSON::XS->new->utf8->decode( $reply );
$t->close;

print Dumper($results);

# http://www.hongkiat.com/blog/jquery-volumn-slider/
# http://loopj.com/jquery-simple-slider/

#setVolume(client.host.mac, newValue);

#print Dumper \@lines;

__END__

Starting Nmap 7.01 ( https://nmap.org ) at 2016-11-07 21:31 MST
Nmap scan report for mezza.pi.eboxr.com (10.0.0.31)
Host is up (0.012s latency).
Not shown: 990 closed ports
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
111/tcp  open  rpcbind
139/tcp  open  netbios-ssn
445/tcp  open  microsoft-ds
3000/tcp open  ppp
3001/tcp open  nessus
3005/tcp open  deslogin
3006/tcp open  deslogind
5000/tcp open  upnp

# import sys
# import telnetlib
# import json
# import threading
# import time
# import json

# telnet = telnetlib.Telnet('127.0.0.1', 1705)
# requestId = 1

# def doRequest( j, requestId ):
#     telnet.write(j + "\r\n")
#     while (True):
#         response = telnet.read_until("\r\n", 2)
#         jResponse = json.loads(response)
#         if 'id' in jResponse:
#             if jResponse['id'] == requestId:
#                 return jResponse;
#     return;

# j = doRequest(json.dumps({'jsonrpc': '2.0', 'method': 'Server.GetStatus', 'id': 1}), 1)
# print(json.dumps(j["result"]["clients"]))

# telnet.close