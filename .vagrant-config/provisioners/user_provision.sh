#!/bin/bash
cd /home/vagrant/code/
source .vagrant-config/config

LOGTITLE="----- Provisioning [user:provision]"
echo "${LOGTITLE}"

# source /home/vagrant/code/.provision/config

echo "${LOGTITLE} Setting up paths..."
mkdir -p ~/bin
mkdir -p ~/logs

# Include our bash scripts
grep -q -F 'source ~/code/.vagrant-config/resources/bash' ~/.bashrc || echo 'source ~/code/.vagrant-config/resources/bash' >> ~/.bashrc

echo "${LOGTITLE} Installing WP-CLI..."
cd ~/bin
curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
mv wp-cli.phar wp
chmod +x wp

echo "${LOGTITLE} Update composer..."
composer -q self-update

echo "${LOGTITLE} Add github RSA key..."
ssh-keyscan github.com >> ~/.ssh/known_hosts