#!/bin/bash

echo -e "\n************************************************************"
echo "Inserire in fstab la configurazione per montare tmp in RAM"
if grep -Fxq "tmpfs       /tmp tmpfs   nodev,nosuid,noexec,nodiratime,size=256M   0 0" /etc/fstab
then
        # code if found
        echo "Modifica già fatta"
else
        # code if not found
        echo "tmpfs       /tmp tmpfs   nodev,nosuid,noexec,nodiratime,size=256M   0 0" >> /etc/fstab
fi

echo -e "\n************************************************************"
echo "Configurazione locale"
dpkg-reconfigure tzdata

echo -e "\n************************************************************"
echo "Codifica fuso orario"
nano /etc/timezone

echo -e "\n************************************************************"
echo "Configurazione tastiera"
dpkg-reconfigure keyboard-configuration

echo -e "\n************************************************************"
echo "Correzione frequenza della posta seriale"
if grep -Fxq "core_freq=250" /boot/config.txt
then
        # code if found
        echo "Modifica già fatta"
else
        # code if not found
        echo "core_freq=250" >> /boot/config.txt
fi


echo -e "\n************************************************************"
echo "Eliminare dal file /boot/cmdline.txt la parte  : console=serial0,115200"
sed -i "s/console=serial0,115200//g" /boot/cmdline.txt

echo -e "\n************************************************************"
echo "Aggiornamento repository raspberry"
apt-get update
apt-get dist-upgrade -y

echo -e "\n************************************************************"
echo "Installo tutti i pacchetti necessari : dnsmasq hostapd putty lighttpd php5 sqlite3 php5-common php5-cgi php5-sqlite mc dnsutils"
apt-get -y install dnsmasq hostapd putty lighttpd php5 sqlite3 php5-common php5-cgi php5-sqlite mc dnsutils

echo -e "\n************************************************************"
echo "Configurazione webserver PHP"
lighty-enable-mod fastcgi
lighty-enable-mod fastcgi-php

echo -e "\n************************************************************"
echo "Copio i file di configurazione attuali e scarico la configurazione da github"
mv /etc/hosts /etc/hosts.orig
wget -P /etc/ https://raw.githubusercontent.com/stblack/raspwifitotem/master/etc/hosts
mv /etc/dhcpcd.conf /etc/dhcpcd.conf.orig
wget -P /etc/ https://raw.githubusercontent.com/stblack/raspwifitotem/master/etc/dhcpcd.conf
mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
wget -P /etc/ https://raw.githubusercontent.com/stblack/raspwifitotem/master/etc/dnsmasq.conf
mv /etc/network/interfaces /etc/network/interfaces.orig
wget -P /etc/network https://raw.githubusercontent.com/stblack/raspwifitotem/master/etc/network/interfaces
mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf.orig
wget -P /etc/lighttpd https://raw.githubusercontent.com/stblack/raspwifitotem/master/etc/lighttpd/lighttpd.conf
mv /etc/hostapd/hostapd.conf /etc/hostapd.conf.orig
wget -P /etc/hostapd https://raw.githubusercontent.com/stblack/raspwifitotem/master/etc/hostapd/hostapd.conf

echo -e "\n************************************************************"
echo "Pagina per bypassare la ricerca del server google in background dentro android 6 "
wget -P /var/www/html/ https://raw.githubusercontent.com/stblack/raspwifitotem/master/var/www/html/generate_204.php
wget -P /var/www/html/ https://raw.githubusercontent.com/stblack/raspwifitotem/master/var/www/html/index.lighttpd.html
wget -P /var/www/html/ https://raw.githubusercontent.com/stblack/raspwifitotem/master/var/www/html/phpinfo.php

echo -e "\n************************************************************"
echo "Aggiungo riga per fare partire in automatico come demone hostapd"
echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" >> /etc/default/hostapd
if grep -Fxq "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\" /etc/default/hostapd
then
        # code if found
        echo "Modifica già fatta"
else
        # code if not found
        echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\" >> /etc/default/hostapd
fi


echo -e "************************************************************"
echo "Riavvio finale dei servizi"
service networking restart
systemctl daemon-reload
service dhcpcd restart
service lighttpd restart
service hostapd restart
service dnsmasq restart

