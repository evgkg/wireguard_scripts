#!/bin/bash
cd /etc/wireguard

CONFIGFILE="wg0.conf"
DEFAULTIP="10.0.0."
MASK="/32"

GREEN='\033[0;32m'
NC='\033[0m'

wg genkey | tee $1_privatekey | wg pubkey > $1_publickey

pbkey=$(cat $1_publickey)
prkey=$(cat $1_privatekey)

ipLS=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' $CONFIGFILE | tail -1 | cut -d . -f 4)
ipLS=$(($ipLS + 1))

resultIp="$DEFAULTIP$ipLS$MASK"

echo "" >> $CONFIGFILE
echo "#$1" >> $CONFIGFILE
echo "[Peer]" >> $CONFIGFILE
echo "PublicKey = $pbkey" >> $CONFIGFILE
echo "AllowedIPs = $resultIp" >> $CONFIGFILE

echo -e "${GREEN}$1 privatekey:${NC}\t $prkey"
echo -e "${GREEN}$1 ip:${NC}\t\t $resultIp"
echo ""

systemctl restart wg-quick@wg0
systemctl status wg-quick@wg0 | head -n 3
