#!/bin/bash

# required by apt to keep track of installed packages
touch /var/lib/dpkg/status
# this keyring is required to access debian repo, which is protected by GPG key
wget http://ftp.us.debian.org/debian/pool/main/d/debian-archive-keyring/debian-archive-keyring_2019.1_all.deb
dpkg -i debian-archive-keyring_2019.1_all.deb

# add apt repo source
touch /etc/apt/sources.list
echo "deb http://ftp.tw.debian.org/debian/ buster main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://ftp.tw.debian.org/debian/ buster main contrib non-free" >> /etc/apt/sources.list

echo "deb http://ftp.tw.debian.org/debian/ buster-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://ftp.tw.debian.org/debian/ buster-updates main contrib non-free" >> /etc/apt/sources.list

echo "deb http://security.debian.org/ buster/updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://security.debian.org/ buster/updates main contrib non-free" >> /etc/apt/sources.list

# add arch in apt.conf

# refresh repo
echo "Updating repo..."
apt-get update