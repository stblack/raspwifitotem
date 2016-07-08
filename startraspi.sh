#divento root
sudo su

#aggiornamento  repository raspberry
apt-get update
apt-get dist-upgrade -y

#inserire in fstab la configurazione per montare /tmp in RAM
echo "tmpfs       /tmp tmpfs   nodev,nosuid,noexec,nodiratime,size=256M   0 0" >> /etc/fstab

#Configurazione locale
dpkg-reconfigure tzdata

#modifica fuso orario
nano /etc/timezone

#correzione frequenza della posta seriale
echo"#correzione frequenza della posta seriale" >> /boot/config.txt
echo"core_freq=250" >> /boot/config.txt

#eliminare dal file /boot/cmdline.txt la parte  : console=serial0,115200
sed -i "s/console=serial0,115200//g" /boot/cmdline.txt

#aggiornamento  repository raspberry
apt-get update
apt-get dist-upgrade -y

#installo tutti i pacchetti necessari
sudo apt-get install dnsmasq hostapd putty lighttpd php5 sqlite3 php5-common php5-cgi php5-sqlite mc dnsutils

#configurazione webserver
lighty-enable-mod fastgci
lighty-enable-mod fastcgi-php
/etc/init.d/lighttpd force-reload

#copio i file di configurazione prima di scaricare la configurazione da github
mv /etc/hosts /etc/hosts.orig
wget -P /etc/ https://raw.githubusercontent.com/stblack/raspwifitotem/master/etc/hosts

cp /etc/dhcpcd.conf /etc/dhcpcd.conf.orig
cp /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
cp /etc/network/interfaces /etc/network/interfaces.orig
cp /etc/lighttpd.conf /etc/lighttpd.conf.orig
cp /etc/hostapd/hostapd.conf /etc/hostapd.conf.orig

