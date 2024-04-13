#!/bin/bash
#######Geomix###################################

# Function to display error message and exit
exit_with_error() {
  echo "Error: $1"
  exit 1
}
# Get template ID and target proxmox
read -p "Please enter the template ID: " TEMPLATE_ID
read -p "Please enter the target proxmox IP address: " TARGET_IP
# Get password for target proxmox
read -s -p "Please enter password for target proxmox: " PASS
if [[ -z ${TEMPLATE_ID} || -z ${TARGET_IP} || -z ${PASS} ]]; then
  exit_with_error "Template ID, target proxmox IP and password cannot be empty."
fi
# Stop the VM
echo "STOPPING ${TEMPLATE_ID}"
qm stop ${TEMPLATE_ID} || exit_with_error "Failed to stop VM ${TEMPLATE_ID}."
# Create a backup of the VM
vzdump ${TEMPLATE_ID} --compress zstd || exit_with_error "Failed to create backup of VM ${TEMPLATE_ID}."
# Copy the backup to the target proxmox
echo "COPYING BACKUP"
TEMPLATE_NAME=$(ls -t /var/lib/vz/dump/ | grep -E ".*${TEMPLATE_ID}.*\.zst" | head -n 1)
echo "${TEMPLATE_NAME}"
sshpass -p${PASS} scp -o StrictHostKeyChecking=no /var/lib/vz/dump/${TEMPLATE_NAME} root@${TARGET_IP}:/var/lib/vz/dump/ || exit_with_error "Failed to copy backup to target proxmox."
echo "LOADING..."
sshpass -p${PASS} ssh -o StrictHostKeyChecking=no root@${TARGET_IP} "qmrestore /var/lib/vz/dump/${TEMPLATE_NAME} ${TEMPLATE_ID}"  || exit_with_error "Failed to restore backup to target proxmox."


