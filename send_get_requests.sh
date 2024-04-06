#!/bin/bash

#delay
delay_time=$1

# Set the number of requests to send
num_requests=$2

# Set the URL for the request
url=$3

# Send the requests
for ((i=1; i<=$num_requests; i++)); do
#  curl -i -G -H "Content-Type: application/json" -d '{"key1":"value1","key2":"value2"}' $url >> get.txt
curl -i -G -H "Content-Type: application/json" $url > /dev/null 
sleep $delay_time 

done
