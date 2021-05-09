#!/bin/bash
# Simple script to check a network device is up. e.g. handy
# for checking if electricity has tripped in a remote
# shed where you might have a fridge/freezer

# Upon failure, it will send a push notification via pushover.

# Usage:
# You will need to supply your API token and User key
# API_TOKEN="xxx" USER_KEY="yyy" ./check_network.sh

check(){
  ping -c 1 $1 2>&1 > /dev/null
  if [ $? -ne 0 ]
  then
    push_notification "$2 is down"
  fi
}

push_notification(){
  MESSAGE="$1"
  TITLE=${TITLE:-"Ping failed"}
  API_TOKEN=${API_TOKEN:-"to-be-supplied-via-environment-variable"}
  USER_KEY=${USER_KEY:-"to-be-supplied-via-environment-variable"}
  curl -s 'https://api.pushover.net/1/messages.json' -X POST -d "token=$API_TOKEN&user=$USER_KEY&message=$MESSAGE&title=$TITLE" -o /dev/null
}

if [ "$1" = "test" ]
then
  TITLE="Test"
  push_notification "Notification checkpoint"
  exit 0
fi

# tplink summerhouse
check 192.168.100.203 "Summer house tp link plug"
