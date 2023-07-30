#!/bin/bash

echo "====evgkg wireguard installer===="

sudo apt udpate && apt upgrade -y
apt install -y wireguard
cd /etc/wireguard
wg genkey | tee /etc/wireguard/privatekey | wg pubkey | tee /etc/wireguard/publickey
chmod 600 privatekey
touch $CONFIGFILE
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

CONFIGFILE="wg0.conf"

ipaddress=$(hostname -i)
webInterface=$(ip a | grep $ipaddress | awk 'NF>1{print $NF}')
serverPrivateKey=$(cat privatekey)
CONFIG=""
CONFIG="${CONFIG}[Interface]\n"
CONFIG="${CONFIG}PrivateKey = ${serverPrivateKey}\n"
CONFIG="${CONFIG}Address = 10.0.0.1/24\n"
CONFIG="${CONFIG}ListenPort = 51830\n"
CONFIG="${CONFIG}PostUp = iptables -A FORWARD -i %i -j ACCEPT; "
CONFIG="${CONFIG}iptables -t nat -A POSTROUTING -o $webInterface -j MASQUERADE\n"
CONFIG="${CONFIG}PostDown = iptables -D FORWARD -i %i -j ACCEPT; "
CONFIG="${CONFIG}iptables -t nat -D POSTROUTING -o $webInterface -j MASQUERADE\n"
echo -e $CONFIG  > $CONFIGFILE

systemctl enable wg-quick@wg0.service
systemctl start wg-quick@wg0.service
systemctl status wg-quick@wg0 | head -n 3

sudo apt install qrencode
