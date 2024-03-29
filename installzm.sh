#!/bin/bash
#Arg Parse from https://betterdev.blog/minimal-safe-bash-script-template/
#justaCasualCoder 2023 - https://github.com/justaCasualCoder
RED='\033[0;31m'
usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-d]

Script for installing Zoneminder on Termux

Available options:

-h, --help      Print this help and exit
-d, --debug     Print script debug info
EOF
  exit
}
  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -d | --debug) set -x ;;
    -?*) echo "Unknown option: $1" && exit 0 ;;
    *) break ;;
    esac
    shift
  done 
echo -n  "Are you sure you want to install Zoneminder? [y/n]: " ; read yn
[[ -z $yn ]] && echo "Going with defualt : n" && yn=n
if [ $yn != y ]; then
    printf "${RED}Aborted\n"
    exit 1
fi
apt update
apt install gpgv
apt install apache2 mariadb-server php libapache2-mod-php php-mysql lsb-release gnupg2 -y
/etc/init.d/mariadb start
cat << EOF | mysql
BEGIN;
CREATE DATABASE zm;
CREATE USER zmuser@localhost IDENTIFIED BY 'zmpass';
GRANT ALL ON zm.* TO zmuser@localhost;
FLUSH PRIVILEGES;
EOF
apt install zoneminder -y
mariadb -u zmuser -pzmpass < /usr/share/zoneminder/db/zm_create.sql
chgrp -c www-data /etc/zm/zm.conf
adduser www-data video
a2enconf zoneminder
a2enmod rewrite
a2enmod headers
a2enmod expires
chown www-data:www-data /etc/apache2/conf-available/zoneminder.conf
sed -i 's/80/8080/g' /etc/apache2/ports.conf
/etc/init.d/mariadb restart
/etc/init.d/apache2 start
/etc/init.d/zoneminder start
yn=""
echo -n "Would you like to make Zoneminder start automatically on startup? (just adds the above command to .profile) [y/n]: " ; read yn
[[ -z $yn ]] && echo "Going with defualt : y" && yn=y
if [ $yn == y ]; then
    echo "/etc/init.d/apache2 start" >> ~/.profile
    echo "/etc/init.d/mariadb start" >> ~/.profile
    echo "/etc/init.d/zoneminder start" >> ~/.profile
fi
cd /
yn=""
wget https://raw.githubusercontent.com/justaCasualCoder/Zoneminder-Termux/main/initzm.sh
echo "You can now connect to Zoneminder at $(ip -oneline -family inet address show | grep "${IPv4bare}/" |  awk '{print $4}' | awk 'END {print}' | sed 's/.\{3\}$//'):8080/zm"
echo "To start it you can run this command at the / dir : bash initzm.sh"
