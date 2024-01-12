#!/bin/bash

# prep docker install
# https://docs.docker.com/engine/install/ubuntu/#install-from-a-package

# Function to use apt if available, otherwise fall back to apt-get
use_apt_get() {
    if command -v apt >/dev/null 2>&1; then
        sudo apt "$@"
    else
        sudo apt-get "$@"
    fi
}

# remove docker if it exists, remove conflicting packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do use_apt_get remove $pkg; done

# Add Docker's official GPG key:
use_apt_get update
use_apt_get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release and echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
use_apt_get update

# Install Docker packages
use_apt_get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
