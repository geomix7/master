#!/bin/bash

VPN_NAME=$1
VPN_CONFIG=$2


DB_PATH=pri_20220927
VPN_FOLDER_PATH=
CREDS_FILE=creds

declare OUTPUT

echo "[*] Retrieve Creds"
	OUTPUT=($(keepassxc.cli show ${DB_PATH} ${VPN_FOLDER_PATH} ${VPN_NAME} -q -s -a username -a password))


USER=${OUTPUT[0]}
PASS=${OUTPUT[1]}


if [ -z "${USER}" ] || [ -z "${PASS}" ]; then
	echo "Something went wrong"; exit 1
fi

echo "${USER}" > ${CREDS_FILE}
echo "${PASS}" >> ${CREDS_FILE}
chmod 600 ${CREDS_FILE}

echo "[*] Exec VPN"
sudo -v
sudo openvpn --config ${VPN_CONFIG} --auth-user-pass ${CREDS_FILE} --daemon
sleep 2
