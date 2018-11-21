#!/bin/bash
set -e

# This script mount the current project in nfsd into minikube

PROJECT_PATH="$( cd "$(dirname "$0")"; cd .. ; pwd -P )";
PROJECT_NAME=$(basename "$PROJECT_PATH");
MINIKUBE_IP=$(minikube ip);
HOST_IP=$(echo -n $(ifconfig | grep $( echo $MINIKUBE_IP | sed -e 's/\([0-9]*.[0-9]*.[0-9]*.\)[0-9]*$/\1/' ) | sed -e 's/[[:space:]]*inet[[:space:]]*\([0-9]*.[0-9]*.[0-9]*.[0-9]*.\).*/\1/' ));

# Ensure that the project folder is not already mounted
minikube ssh "sudo umount /host-sources/${PROJECT_NAME}"

# # Make the project folder available for minikube
echo "Make the project $PROJECT_NAME available for $MINIKUBE_IP with nfsd..."
sudo sed -i '' '/^\s*$/d' /etc/exports               # Remove empty line
sudo sed -i '' 's|'$PROJECT_PATH'.*||g' /etc/exports # Remove line containing the project
echo "$PROJECT_PATH $(minikube ip) -alldirs -mapall="$(id -u)":"$(id -g)""   | sudo tee -a /etc/exports &>/dev/null # Add the project folder
sudo nfsd restart
# End Make the project folder available for minikube

# Mount the folder project into the VM on the path /host-sources/
echo "Make the project $PROJECT_NAME available in minikube under /host-sources/${PROJECT_NAME}"
mount_cmd=$(echo "sudo mount -t nfs ${HOST_IP}:${PROJECT_PATH} /host-sources/${PROJECT_NAME}")
minikube ssh "sudo mkdir -p /host-sources/$PROJECT_NAME"
minikube ssh "$mount_cmd"

echo "Here is the ls /host-sources/${PROJECT_NAME} result :"
minikube ssh "ls /host-sources/${PROJECT_NAME}"
