#!/bin/bash

if [ $# -ne 1 ]; then
    echo Invalid argument: Usage ./connect_as.sh as_number
    exit 1
fi

WORKDIR=/home/ubuntu/mini_internet_project/platform/

as_number=$1
port=$(expr 2000 + $as_number)

while read n ps; do
    as_valid+=($n)
    if [ $as_number -eq $n ]; then
        pass=$ps
    fi
done < "$WORKDIR/groups/passwords.txt"

if [ -z $pass ]; then
    echo "Invalid AS number: Available AS (${as_valid[@]})"
    exit 1
fi

# public ip (AWS)
sshpass -p $pass ssh -o StrictHostKeyChecking=no -p $port root@$(curl -s ifconfig.me)

# # private ip (UB)
# sshpass -p $pass ssh -o StrictHostKeyChecking=no -p $port root@$(hostname -I | awk '{print $1}')
