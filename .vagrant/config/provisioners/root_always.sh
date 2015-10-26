#!/bin/bash
cd /home/vagrant/code/
source .vagrant/config/config

LOGTITLE="----- Provisioning [root:always]"
echo "${LOGTITLE}"

echo "${LOGTITLE} Deleting vhosts"
rm -f /etc/apache2/sites-enabled/*

echo "${LOGTITLE} Creating vhosts"

find * -prune -type d | while read PROJECT; do
    sed "s/__VHOSTNAME__/$PROJECT/g" .vagrant/config/resources/vhost.template > /etc/apache2/sites-enabled/$PROJECT.conf;
done

service apache2 start # If not running for some reason
service apache2 reload