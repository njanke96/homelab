#!/bin/bash

set -e

# Update and Upgrade
sudo apt update && sudo apt upgrade

# QEMU Guest Agent
sudo apt install -y qemu-guest-agent

# Essential Packages
sudo apt install -y neovim \
  htop \
  nfs-common

# Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
sudo usermod -aG docker $(whoami)

# dtop
curl -sSfL https://amir20.github.io/dtop/install.sh | bash

echo ""
echo "---"
echo "Done installing the essentials, don't forget to reboot"
