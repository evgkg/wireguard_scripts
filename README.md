

## Add new client to server
script newclient.sh

> :warning: **The script makes sense to use only when wireguard is already configured**

 
0. generates keys for a new client
1. adds a new client to the configuration file.
2. restarts wireguard
### How to use
0. clone this repo in /etc/wireduard
1. run `./newclient.sh clientname`\
u can also create a few clients at one time: `./newclient.sh clientname1 clientname2 ... clientnameN`
