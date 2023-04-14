#!/bin/bash
cd /etc/wireguard
wg genkey | tee $1_privatekey | wg pubkey > $1_publickey

pbkey=$(cat $1_publickey)
prkey=$(cat $1_privatekey)

configFile="wg0.conf"

defaultIp="10.0.0."
mask="/32"
ipLS=$(cat $configFile | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | tail -1 | cut -d . -f 4)
ipLS=$(($ipLS + 1))

resultIp="$defaultIp$ipLS$mask"

echo "" >> $configFile
echo "#$1" >> $configFile
echo "[Peer]" >> $configFile
echo "PublicKey = $pbkey" >> $configFile
echo "AllowedIPs = $resultIp" >> $configFile

systemctl restart wg-quick@wg0
systemctl status wg-quick@wg0 | head -n 3
echo ""

GREEN='\033[0;32m'
NC='\033[0m'
echo -e "${GREEN}privatekey:${NC}\t $prkey"
echo -e "${GREEN}ip:${NC}\t\t $resultIp"
