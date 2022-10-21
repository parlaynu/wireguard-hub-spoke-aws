#!/usr/bin/env bash

set -e

#MY_PUBLIC_IP="$(curl --silent https://diagnostic.opendns.com/myip)" 
MY_PUBLIC_IP="$(dig @resolver1.opendns.com +short myip.opendns.com)" 

jq -n --arg my_public_ip "$MY_PUBLIC_IP" '{"my_public_ip":$my_public_ip}'

