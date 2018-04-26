#!/bin/bash

# @file
# Base startup script.

# Ensure vagrant numeric uid/gid matches.
# @param $1
# User id.
# @param $2
# Group id.
ensure_user_ids(){
  # Check if change is needed.
  OWN_CHANGED=0
  if [ "$(id -u vagrant)" != "$1" ]; then
    usermod -u $1 vagrant
    echo "User ID changed to $1."
    OWN_CHANGED=1
  fi
  if [ "$(id -g vagrant)" != "$2" ]; then
    groupmod -g $2 vagrant
    echo "Group ID changed to $2."
    OWN_CHANGED=1
  fi
  if [ $OWN_CHANGED -eq 1 ]; then
    chown -R vagrant:vagrant /home/vagrant
  fi
}

# Do nothing if we have no arguments, or we're called with root ids.
if [ ! -z $1 ] || [ ! -z $2 ] || [ $1 -lt 1 ] || [ $1 -lt 1 ]; then
  ensure_user_ids $1 $2
fi

if [ -e /run/sshd.pid ]; then
  rm /run/sshd.pid
fi
/usr/sbin/sshd -D