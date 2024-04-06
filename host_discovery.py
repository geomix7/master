#!/bin/python3

import argparse
import subprocess
import nmap

# Define the command-line arguments
parser = argparse.ArgumentParser()
parser.add_argument('target', help='IP address or subnet to scan')
args = parser.parse_args()

# Check if nmap is installed
try:
    subprocess.run(['nmap', '-v'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
except subprocess.CalledProcessError:
    # nmap is not installed, so prompt the user to install it
    print('nmap is not installed. Please install it and try again.')
    exit()

# Create an instance of the nmap.PortScanner() class
nm = nmap.PortScanner()

# Perform the host discovery scan
nm.scan(hosts=args.target, arguments='-sn')

# Parse the results and print the status of each host
for host in nm.all_hosts():
    if nm[host].state() == 'up':
        print(f'{host} is up')
    else:
        print(f'{host} is down')
