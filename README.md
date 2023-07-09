> :warning: **The script only for ubuntu server**


### How to use

install wg server:
```bash
curl -O https://raw.githubusercontent.com/weikelake/wireguard_scripts/master/createwg.sh
chmod +x createwg.sh
./createwg.sh
```
add new client
```bash
cd /etc/wireguard
curl -O https://raw.githubusercontent.com/weikelake/wireguard_scripts/master/newclient.sh
chmod +x newclient.sh
./newclient.sh clientname
```
u can also create a few clients at one time: 
```bash
./newclient.sh clientname1 clientname2 ... clientnameN
```
