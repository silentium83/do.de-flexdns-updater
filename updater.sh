#!/bin/bash

INTERVAL=${INTERVAL:=300}

if [ -z $USERNAME ] || [ -z $PASSWORD ];
then
  echo "Error: specify environment vaiables USERNAME and PASSWORD"
  exit 1;
fi

while [ : ]
do
  IPV4=$(curl -s https://api.ipify.org)
  IPV6PREFIX=$(ip -6 addr|awk '{print $2}'|grep -P '^(?!fe80)[[:alnum:]]{4}:.*/64'|head -n1|rev|cut -c23-|rev)
  curl -s --user $USERNAME:$PASSWORD "https://ddns.do.de?myip=${IPV4}&ip6lanprefix=${IPV6PREFIX}:/64"
  echo 
  sleep $INTERVAL
done
