#!/bin/bash

# Docker host ip
export DD_AGENT_IP=`/sbin/ip route|awk '/default/ { print $3 }'`

# Start applications
/usr/bin/supervisord
