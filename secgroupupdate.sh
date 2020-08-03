#!/bin/bash

# your favorite way of getting public IP below:
# see more: https://www.cyberciti.biz/faq/how-to-find-my-public-ip-address-from-command-line-on-a-linux/
ip="$(dig +short myip.opendns.com @resolver1.opendns.com)"

if [ "$1" = "undo" ]; then
  protocol="${2:-tcp}"
  port="${2:-22}"
else
  protocol="${1:-tcp}"
  port="${2:-22}"
fi

cidr="${ip}/32"
lookup_range="$(echo "$ip" | sed -r 's@(.*)\.(.*)\.(.*)\.(.*)@\1.\2.\3.*/32@')"

if [ ! -f groups.txt ]; then
  groups="$(aws ec2 describe-security-groups --filters Name=ip-permission.cidr,Values="$lookup_range" --query "SecurityGroups[*].[GroupName]" --output text | tee groups.txt)"
else
  groups="$(<groups.txt)"
fi

if ! echo "$1" | grep -q undo >/dev/null 2>&1; then
  echo "$groups" | while read -r group; do
    aws ec2 authorize-security-group-ingress --group-name "$group" --protocol "$protocol" --port "$port" --cidr "$cidr"
  done
else
  echo "$groups" | while read -r group; do
    aws ec2 revoke-security-group-ingress --group-name "$group" --protocol tcp --port 22 --cidr "$cidr"
  done
fi

# read -r -p 'Do you wish to delete groups.txt? [y/n] ' answer
# if [ "$answer" = "y" ]; then
#   rm -f groups.txt
# fi
