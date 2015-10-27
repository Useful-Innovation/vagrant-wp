#!/bin/bash
cd /home/vagrant/code/
source .vagrant/config/config

LOGTITLE="----- Provisioning [root:always]"
echo "${LOGTITLE}"

echo "${LOGTITLE} Deleting vhosts"
rm -f /etc/apache2/sites-enabled/*

echo "${LOGTITLE} Creating vhosts"
mkdir -p /home/vagrant/logs
find * -prune -type d | while read PROJECT; do
    sed "s/__VHOSTNAME__/$PROJECT/g" .vagrant/config/resources/vhost.template > /etc/apache2/sites-enabled/$PROJECT.conf;
done

echo "${LOGTITLE} Creating databases"
find * -prune -type d | while read PROJECT; do
    mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS ${PROJECT} CHARACTER SET utf8 COLLATE utf8_swedish_ci"
done

service apache2 start # If not running for some reason
service apache2 reload