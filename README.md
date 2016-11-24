Snapcast Volume Control: Web UI
===============================

This is a simple [Snapcast](https://github.com/badaix/snapcast) webapp designed to control volume of all snapcast clients using the JSON::RPC API.
This app is powered by Perl & Dancer2.

**S**y**n**chronous **a**udio **p**layer

[Snapcast](https://github.com/badaix/snapcast)  is a multi-room client-server audio player, where all clients are time synchronized with the server to play perfectly synced audio. It's not a standalone player, but an extension that turns your existing audio player into a Sonos-like multi-room solution.
The server's audio input is a named pipe `/tmp/snapfifo`. All data that is fed into this file will be send to the connected clients. One of the most generic ways to use Snapcast is in conjunction with the music player daemon ([MPD](http://www.musicpd.org/)) or [Mopidy](https://www.mopidy.com/), which can be configured to use a named pipe as audio output.

How does this UI works
----------------------

This is using the JSON-RPC API, to first get the list of all connected clients,
and display a volume dial for each of them.


![Snapcast](https://raw.githubusercontent.com/atoomic/snapcast-volume-ui/master/doc/screenshot.png)

Installation
------------

This webui is using perl and Dancer2. 
You can install it on any server: where the snapcast server is running, or on a snapcast client server or any other server :-)

* This is recommended to use perlbrew and use a recent version of perl.
* install cpanm
* then run 'install.sh' which is for now mainly running 'cpanm --installdeps .'
* edit the config.yml file (view Configuration section)
* you can then use plack or any other webserver to run the server, './devel-server' should run a webserver on port :5000.

Configuration
-------------
Before running the webserver you should edit the configuration file

Set your snapcast server hostname/ip and port (optional, using 1705 by default):

	snapcast:
	  server:
	     host: 'your.snapcast.server.ip'
	     port: 1705

This is optional, but you can set a label & color to each room using the rooms sections:
By default all connected clients are going to be listed using their mac address.

    rooms:
	    'b8:27:eb:f3:23:f0':
	       color: '#0C0'
	       name:  'Mezzanine'
	    'b8:27:eb:4c:27:87':
	       color: '#C00'
	       name:  'Game Room'

If you do not want to display some clients you can ignore them:

	  ignore:
	    - 'b8:27:eb:a6:76:a5'
	    - 'b8:27:eb:a6:76:a6'    

Wish List
-------
Unordered list of features
- [X] **Basic UI** use JSON-RPC API to change client volume, responsive with mobile devices
- [ ] **Doc** Improve doc & installation process
- [ ] **More control** mute, ...
- [ ] **UI** improve UI and adjust the size correctly for each device, color improvements
