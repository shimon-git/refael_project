#!/bin/bash

# Ensure the script is run as root or with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or use sudo."
    exit 1
fi

# Updating the package list
apt update -y

# Installing required dependencies
apt install -y software-properties-common

# Adding Ansible PPA
add-apt-repository --yes --update ppa:ansible/ansible

# Installing Ansible
apt install -y ansible
