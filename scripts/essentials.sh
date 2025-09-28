#!/bin/bash

set -e

echo 'essentials: Update and Upgrade'
sudo apt update && sudo apt upgrade

echo 'essentials: QEMU Guest Agent'
sudo apt install -y qemu-guest-agent

echo 'essentials: Essential Packages'
sudo apt install -y neovim \
  htop \
  nfs-common \
  curl

echo 'essentials: Docker'
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
sudo usermod -aG docker $(whoami)

echo 'essentials: dtop'
curl -sSfL https://amir20.github.io/dtop/install.sh | bash

echo 'essentials: NodeJS'
curl -sSfL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

NVM_DIR="$HOME/.nvm";
source "$NVM_DIR/nvm.sh";

nvm install --lts
nvm alias default 'lts/*'
nvm use 'lts/*'

echo 'essentials: Helix & Relevant Language support'

sudo add-apt-repository ppa:maveonair/helix-editor
sudo apt update
sudo apt install helix

sudo apt install shellcheck shfmt
npm install -g dockerfile-language-server-nodejs
npm install -g @microsoft/compose-language-service
npm install -g bash-language-server

curl -o "$HOME/.config/helix/config.toml" "https://raw.githubusercontent.com/njanke96/homelab/master/configs/helix/config.toml"

echo ""
echo "---"
echo "Done installing the essentials, don't forget to reboot"
