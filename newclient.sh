#!/bin/bash
cd /etc/wireguard

CONFIGFILE="wg0.conf"
DEFAULTIP="10.0.0."
MASK="/32"

GREEN='\033[0;32m'
NC='\033[0m'

usage()
{
	echo "USAGE: ./newclient.sh clent1 client2 ...clientN, where N >= 1"
}

if [[ $# -eq 0 ]]
then
	usage
	exit 1
fi

for var in "$@"
do
	wg genkey | tee ${var}_privatekey | wg pubkey > ${var}_publickey

	pbkey=$(cat ${var}_publickey)
	prkey=$(cat ${var}_privatekey)

	ipLS=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' $CONFIGFILE | tail -1 | cut -d . -f 4)
	ipLS=$(($ipLS + 1))

	resultIp="${DEFAULTIP}${ipLS}${MASK}"

	echo "" >> $CONFIGFILE
	echo "#$var" >> $CONFIGFILE
	echo "[Peer]" >> $CONFIGFILE
	echo "PublicKey = $pbkey" >> $CONFIGFILE
	echo "AllowedIPs = $resultIp" >> $CONFIGFILE

	echo -e "${GREEN}$var privatekey:${NC}\t $prkey"
	echo -e "${GREEN}$var ip:${NC}\t\t $resultIp"
	echo ""
done

systemctl restart wg-quick@wg0
systemctl status wg-quick@wg0 | head -n 3
