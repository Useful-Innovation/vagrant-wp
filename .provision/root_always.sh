#!/bin/bash

LOGTITLE="----- Provisioning [root:always]"
echo "${LOGTITLE}"

# source /home/vagrant/code/.provision/config

echo "${LOGTITLE} Deleting vhosts"
rm -f /etc/apache2/sites-enabled/*

echo "${LOGTITLE} Creating vhosts"
cd /home/vagrant/code/

find * -prune -type d | while read PROJECT; do
    sed "s/__VHOSTNAME__/$PROJECT/g" .provision/resources/vhost_template > /etc/apache2/sites-enabled/$PROJECT.conf;
done

service apache2 start # If not running for some reason
service apache2 reload