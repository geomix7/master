#!/bin/bash

#### Proxmox Setup by Geomix ####

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No color

read -rp "Please provide Proxmox Hostname : " HOST_NAME

function enable_no_subscription_repo() {
  if ping -c 1 google.com >> /dev/null; then
    echo '[*] Remove Enterprise repo'
    echo rm -r /etc/apt/sources.list.d/pve-enterprise.list
    echo '[*] Enable No-Subscription repo'
    echo "deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list
  else
    echo -e "${RED}ERROR: No internet access!${NC}"
    exit 1
  fi
}

function install_packages() {
  echo "[*] Install packages"
  apt -qqq update
  apt install -qqq -y net-tools tcpdump
  echo -e "${GREEN}✓ ✓ ✓ Packages successfully installed!${NC}"
}

function set_timezone() {
ln -sf "/usr/share/zoneinfo/UTC" /etc/localtime
  echo "UTC" > /etc/timezone
}

function set_dns() {
  echo "nameserver 192.168.88.57" >> /etc/resolv.conf
  echo "nameserver 8.8.8.8 " >> /etc/resolv.conf
  echo -e "${GREEN}✓ ✓ ✓ DNS settings updated${NC}"

}

function set_hostname() {

  hostnamectl set-hostname "${HOST_NAME}"
  echo -e "${GREEN}Hostname set to ${HOST_NAME} ${NC}"
}


# Call the functions
set_hostname
set_timezone
set_dns
enable_no_subscription_repo
install_packages

