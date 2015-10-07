#!/bin/bash

LOGTITLE="----- Provisioning [root:provision]"
echo "${LOGTITLE}"

source /home/vagrant/code/.provision/config

apt-get install -yqq debconf-utils

echo "${LOGTITLE} Install server components"

# Turn off interactive debconf
export DEBIAN_FRONTEND=noninteractive

# Set these to prevent mysql-server installation from prompting for root password.
# This sets empty password
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

apt-get install -yqq \
    apache2=${INSTALL_APACHE_VERSION} \
    php5=${INSTALL_PHP_VERSION} \
    mysql-server=${INSTALL_MYSQL_VERSION} \
    php5-mysql \

a2enmod rewrite

echo "${LOGTITLE} Install server tools"
apt-get install -yqq \
    git \

echo "${LOGTITLE} Install node packages"
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -yqq nodejs
npm install -g grunt-cli --silent
npm install -g bower --silent

# Install composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer