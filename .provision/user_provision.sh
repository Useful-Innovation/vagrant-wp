#!/bin/bash

LOGTITLE="----- Provisioning [user:provision]"
echo "${LOGTITLE}"

# source /home/vagrant/code/.provision/config

echo "${LOGTITLE} Setting up paths..."
mkdir -p ~/bin
mkdir -p ~/tools

mkdir -p ~/code/.logs

PATH=~/bin:$PATH

ln -sf /usr/local/bin/composer ~/bin/composer # Servant expects it to be there

# Include our bash scripts
grep -q -F 'source ~/code/.provision/resources/bash' ~/.bashrc || echo 'source ~/code/.provision/resources/bash' >> ~/.bashrc


echo "${LOGTITLE} Installing WP-CLI..."
cd ~/bin
curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
mv wp-cli.phar wp
chmod +x wp

echo "${LOGTITLE} Update composer..."
composer -q self-update

echo "${LOGTITLE} Add github RSA key..."
ssh-keyscan github.com >> ~/.ssh/known_hosts

echo "${LOGTITLE} Setting up GoBrave Tools..."
cd ~/tools
if ! [ -d ./gobrave-tools ]; then
    git clone git@github.com:Useful-Innovation/gobrave-tools.git
    cd gobrave-tools/Servant
    composer install  -qn --no-progress
fi

ln -sf ~/tools/gobrave-tools/Servant/index.php ~/bin/servant

cd ~/tools
if ! [ -d ./server ]; then
    git clone git@github.com:Useful-Innovation/server.git
fi


echo "${LOGTITLE} Setting up Servant..."
touch ~/.ssh/config
servant server:set_path ~/tools/server/servers/
servant server:set_config ~/.ssh/config