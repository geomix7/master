#!/bin/bash

echo "Enter IP addresses separated by space:"
read -a IPS

for IP in "${IPS[@]}"
do
  echo "Testing IP address: $IP"
  curl -o /dev/null -s -w 'Establish Connection: %{time_connect}s\nTTFB: %{time_starttransfer}s\nTotal Time: %{time_total}s\n' $IP
done
