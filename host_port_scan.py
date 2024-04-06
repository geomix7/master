#!/bin/python3

import argparse
import socket

# Define the command-line arguments
parser = argparse.ArgumentParser()
parser.add_argument('host', help='host to scan')
parser.add_argument('port_range', help='range of ports to scan (e.g. 1-1024)')
args = parser.parse_args()

# Parse the port range
start_port, end_port = map(int, args.port_range.split('-'))

# Create a socket object
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.settimeout(2)

# Perform the port scan on each port in the range
open_ports = []
for port in range(start_port, end_port+1):
    try:
        # Attempt to connect to the port
        s.connect((args.host, port))
        open_ports.append(port)
    except:
        pass

# Close the socket
s.close()

# Print the open ports
if len(open_ports) > 0:
    port_range_str = f'{args.port_range}'
    open_ports_str = ', '.join(map(str, open_ports))
    print("-" * 50)
    print(f'Open ports on {args.host} ({port_range_str}): {open_ports_str}')
    print("-" * 50)
else:
    print("-" * 50)
    print(f'No open ports found on {args.host} ({args.port_range})')
    print("-" * 50)
