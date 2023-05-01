#!/bin/bash
RED='\033[0;31m'
set -Eeuo pipefail
echo -n "Which version of ZM do you want to use? [1.34 or 1.36]: " ; read version
case $version in
	1.34)
     echo "You selected 1.34!"
     ;;
    1.36)
     echo "You selected 1.36"
     ;;
    *)
     echo "Unkown version $version"
     exit 0
esac
echo -n "Are you sure you want to install Zoneminder? [y/n]: " ; read an
if [ $an != y ]; then
    printf "${RED}Aborted\n"
    exit 0
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
END;
EOF
if [ $version == "1.34" ]; then
    apt install zoneminder -y
else 
     echo 'deb http://deb.debian.org/debian bullseye-backports main contrib' >> /etc/apt/sources.list
     apt update && apt -t bullseye-backports install zoneminder
fi
mariadb -u zmuser -pzmpass < /usr/share/zoneminder/db/zm_create.sql
chgrp -c www-data /etc/zm/zm.conf
a2enconf zoneminder
adduser www-data video
a2enconf zoneminder
a2enmod rewrite
a2enmod headers
a2enmod expires
sed -i 's/80/8080/g' /etc/apache2/ports.conf
/etc/init.d/mariadb restart
/etc/init.d/apache2 start
/etc/init.d/zoneminder start
echo -n "Would you like to make Zoneminder start automatically on startup? (just adds the above command to .profile) [y/n]: " ; read answer
if [ $answer == y ]; then
    echo "/etc/init.d/apache2 start" >> ~/.profile
    echo "/etc/init.d/mariadb start" >> ~/.profile
    echo "/etc/init.d/zoneminder start" >> ~/.profile
fi
cd /
wget https://raw.githubusercontent.com/justaCasualCoder/Zoneminder-Termux/main/initzm.sh 
echo "You can now connect to Zoneminder at $(ip -oneline -family inet address show | grep "${IPv4bare}/" |  awk '{print $4}' | awk 'END {print}' | sed 's/.\{3\}$//'):8080"
echo "To start it you can run this command at the / dir : bash initzm.sh"