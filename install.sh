#!/bin/bash

# Check
if [ `whoami` != "root" ]; then 
	echo "Please run under the root user."
	exit 2
fi

# Install base tool
apt-get install -yqq software-properties-common
apt-add-repository ppa:vbernat/haproxy-1.5
apt-get update -yqq
apt-get install -yqq git curl wget tar gzip

# Prepare Syslogd
# Install Syslogd
apt-get install -yqq busybox-syslogd

# Run Syslogd
syslogd -R 127.0.0.1 -L

# Prepare HAProxy
HAPROXY_EXE=`which haproxy`
if [ -z "$HAPROXY_EXE" ]; then
    # Install HAProxy
    apt-get install -yqq haproxy

    # Config HAProxy
    echo -e "\nlisten stats :1936\n      mode http\n      stats enable\n      stats hide-version\n      stats realm Haproxy\ Statistics\n      stats uri /\n      stats auth Username:Password\n" | tee -a /etc/haproxy/haproxy.cfg 
    echo -e "\nENABLED=1\n" | tee -a /etc/default/haproxy 
    mkdir /dev/log
          
    # Run HAProxy
    service haproxy start
fi

# Download dataman-bamboo
VERSION=0.9.0
P_NAME=dataman-bamboo-$VERSION.tar.gz
wget https://github.com/Dataman-Cloud/bamboo/releases/download/dr-$VERSION/$P_NAME
BAMBOO_HOME=/opt/bamboo
mkdir $BAMBOO_HOME && tar xzvf dataman-bamboo-0.9.0.tar.gz -C $BAMBOO_HOME --strip-components=1
rm -f $P_NAME*
chmod -R 775 $BAMBOO_HOME