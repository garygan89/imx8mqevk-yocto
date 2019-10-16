#!/bin/bash
# Setup DNS to use Google 8.8.8
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

# modify sudo file to allow 'sudo' group to use sudo command
echo "sudo   ALL=(ALL) ALL" >> /etc/sudoers

# configure network, yocto uses connman by default
connmanctl config ethernet_00049f05a879_cable --ipv4 manual 140.113.169.17 255.255.255.0 140.113.169.254
connmanctl config ethernet_00049f05a879_cable --nameservers 8.8.8.8 8.8.4.4
systemctl restart connman