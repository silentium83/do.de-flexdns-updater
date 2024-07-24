#!/bin/bash

: "${DATA:=/data}"
: "${INTERVAL:=300}"
: "${SET_IPV4:=true}"
: "${SET_IPV6PREFIX:=true}"

if [ -z $USERNAME ] || [ -z $PASSWORD ]; then
  echo "Error: specify environment variables USERNAME and PASSWORD"
  exit 1
fi

if ! $SET_IPV4 && ! $SET_IPV6PREFIX; then
  echo "Error: at least one of SET_IPV4 and SET_IPV6PREFIX must be true"
  exit 2
fi

while [ : ]
do
  URL="https://ddns.do.de?"
  UPDATE=false
  if $SET_IPV4; then
    IPV4=$(curl -s https://api.ipify.org)
    URL="${URL}myip=${IPV4}&"
    [ ! -e "${DATA}/ipv4" ] || [ "${IPV4}" != "$(<"${DATA}"/ipv4)" ] && UPDATE=true
  fi
  if $SET_IPV6PREFIX; then
    IPV6PREFIX=$(ip -6 addr|awk '{print $2}'|grep -P '^(?!fe80)[[:alnum:]]{4}:.*/64'|head -n1|rev|cut -c23-|rev)
    URL="${URL}ip6lanprefix=${IPV6PREFIX}:/64"
    [ ! -e "${DATA}/ipv6prefix" ] || [ "${IPV6PREFIX}" != "$(<"${DATA}"/ipv6prefix)" ] && UPDATE=true
  fi
  if $UPDATE || [[ $(date +%s -r "${DATA}"/updated 2>/dev/null) -lt $(date +%s --date="25 days ago") ]]; then
    if curl -s --user $USERNAME:$PASSWORD "${URL}"; then
      touch "${DATA}/updated"
      echo "${IPV4}" > "${DATA}/ipv4"
      echo "${IPV6PREFIX}" > "${DATA}/ipv6prefix"
    fi
  fi
  sleep $INTERVAL
done
