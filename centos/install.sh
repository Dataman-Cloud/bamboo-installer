#!/bin/bash

# Check
if [ `whoami` != "root" ]; then 
	echo "Please run under the root user."
	exit 2
fi

# Install base tool
yum install -y -q git curl wget tar gzip

# Prepare Rsyslog
# Install Rsyslog
yum install -y -q rsyslog

# Run Rsyslog
rsyslogd -l 127.0.0.1

# Prepare HAProxy
HAPROXY_EXE=`which haproxy`
if [ -z "$HAPROXY_EXE" ]; then
    # Install HAProxy
    yum install -y -q haproxy
          
    # Run HAProxy
    haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -D
fi

# Download dataman-bamboo
VERSION=0.9.0
P_NAME=dataman-bamboo-$VERSION.tar.gz
wget https://github.com/Dataman-Cloud/bamboo/releases/download/dr-$VERSION/$P_NAME
BAMBOO_HOME=/opt/bamboo
mkdir $BAMBOO_HOME && tar xzvf dataman-bamboo-0.9.0.tar.gz -C $BAMBOO_HOME --strip-components=1
rm -f $P_NAME*
chmod -R 775 $BAMBOO_HOME