#!/bin/bash

HELP="
./antminertroll.sh [-h] [-s] [-d DIR] [-t NUMBER_OF_SECONDS]
 All arguments are optional:

 -h = SHOW THE HELP

 -s = SKIP network scan and just use current antminer_ips file for servers list

 -t=NUMBER_OF_SECONDS = amount of seconds to wait between querying the antminers

 EXAMPLES:

 # Find all antminers on the local CIDR subnet, then probe them for data every 45 seconds
 ./antminertroll.sh -t=45

 # Skip searching for antminers and use already-present antminer_ips file. Scan once per hour.
 ./antminertroll.sh -s -t=3600 
"

ARG1=$1
SKIP=NO
TIME=60

if [ "$ARG1" = "-h" ]; then
  echo "$HELP"
  exit 0
fi

for i in "$@"
do
case $i in
    -s*)
    SKIP=YES
    ;;
    -d=*|--dir=*)
    DIR="${i#*=}"
    ;;
    -t=*|--time=*)
    TIME="${i#*=}"
    ;;

esac
done
echo SKIP = ${SKIP}
echo DIR = ${DIR}
echo TIME = ${TIME}

# check system $PATH for dependencies
type -P "jq" && echo "jq is available" || exit 1
type -P "nmap" && echo "nmap is available" || exit 1
type -P "ip" && echo "ip is available" || exit 1

if [ "$SKIP" = "NO" ]; then
  # get ip for device serving the current internet connection
  IP=$(ip route get 1 | sed -n 's/^.*src \([0-9.]*\) .*$/\1/p')
  # ascertain the CIDR block to search for antminers
  CIDR="${IP%.*}.0/24"
  echo "Scanning on CIDR: $CIDR"

  # nmap goodness to get all da antminers on this CIDR. blackice-icecap seems unique to these units
  SCANRESULTS=$(nmap $CIDR -oG - | grep blackice-icecap)
  IP_SCAN="$(echo "${SCANRESULTS%()*}" | tr -d 'Host: ')"

  IFS=$'\n'
  # remove stale antminer ip address file
  rm antminer_ips
  # iterate through each IP address identified as an antminer and write it to the ip address file
  for line in $IP_SCAN; do echo "${line%()*}" | tr -d 'Host: ' > antminer_ips; done
fi


echo "starting $TIME second queries"

parallel -a antminer_ips ./antminer_query.sh

while sleep $TIME; do parallel -a antminer_ips ./antminer_query.sh; done
