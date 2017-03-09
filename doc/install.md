Installation instructions for the snapcast-volumio-ui

## Debian-like systems

These instructions should work reasonably for most Debian-based distributions, including as the Ubuntu family. 
They were tested on a headless Raspberry Pi 2 model B, using Raspbian Jesse Lite (2017-02-16), 
which is a reasonably minimal base image, so they should hopefully include all the dependencies you need. 

Advanced configurations could involve:

* web server that is more streamlined or scalable than plack, 
* a perl-and-cpan driven build, such as perlbrew and cpanm, though it might take for longer to install fresh

However here we focus on getting the software functioning in the minimum time with a minimum of effort

You could use one of your snapcast client devices, as it might be reasonably idle, 
but these instructions do not depend on any local snapcast installation or configuration. 

```
### INSTALL FROM REPOS

# install dependency packages - translated from requires list in 
# [https://github.com/atoomic/snapcast-volume-ui/blob/master/cpanfile]
# time hires is in perl core included in raspbian lite
sudo apt-get install -y libdancer2-perl libplack-perl libclass-accessor-class-perl \ 
  libtest-harness-perl libnet-telnet-perl libtemplate-perl libjson-xs-perl \ 
  libfile-fcntllock-perl

# now let's copy the code from the git repo
# v.11 not ready yet
# SNAPVOL_VERSION=0.11 
SNAPVOL_VERSION=0.10.0
SNAPVOL_BRANCH=snapcast/v$SNAPVOL_VERSION
# create the destination folder
mkdir -p ~/snapvol-$SNAPVOL_VERSION/
# download the branch, following redirects and showing errors
curl -SL https://github.com/atoomic/snapcast-volume-ui/tarball/$SNAPVOL_BRANCH \ 
  | tar -xzC ~/snapvol-$SNAPVOL_VERSION/ --strip-components=1

# Workaround because I couldn't find a Simple Accessor package in the repos
sudo mkdir -p /usr/share/perl5/Simple
cd /usr/share/perl5/Simple
sudo curl -O https://raw.githubusercontent.com/atoomic/Simple-Accessor/master/lib/Simple/Accessor.pm
cd ~/snapvol-$SNAPVOL_VERSION/


### Check your network details

# get the IP for my server and mac addresses for my clients
# please change these to your own hostnames
ping -c 1 mysnapserver
ping -c 1 mysnapclient1
ping -c 1 mysnapclient2
arp

### Configure

cd ~/snapvol-$SNAPVOL_VERSION/
cp config.yml.example config.yml
# set your own snapcast server IP & colors (view Configuration section)
# server host must be IP address
editor config.yml


### TEST

plackup -E development -p 8080 ./bin/app.psgi

# now browse to http://thishostname:8080/ to make sure it works, 
# observing the console output in case of issues


### INSTALL AS A SERVICE

cd systemctl
cp snapcast-ui.service.example snapcast-ui.service
editor snapcast-ui.service
```
You must change the Execstart line to be (manually replacing $SNAPVOL_VERSION with the version number)

```
ExecStart=/usr/bin/plackup -E production -p 8080  /home/pi/snapvol-$SNAPVOL_VERSION/bin/app.psgi
```
now carry on with

```
editor Makefile
```
Unfortunately the current version of the Makefile does not account for the debian systemd path convention 
`/lib/systemd/system/` and so you will have to remove the `/usr` from the beginning of it to leave

```
	install snapcast-ui.service /lib/systemd/system/
```
And finish with 

```
sudo make all
# it should show as active, but is not yet 'enabled' for autostart so
sudo systemctl enable snapcast-ui.service
```

reboot and test again.

Now crank up those sounds, and enjoy! :)

