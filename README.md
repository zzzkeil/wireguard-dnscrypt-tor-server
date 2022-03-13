# Wireguard-tor-Server 


#### status 2022.03.12 : 
test to update my script and debian 11 support

** whats working :  
* wireguard
* dnscrypt
* tor

( some issues with .onion have to be fixed  / not working in this version )

### Project start 2021.01.24

## ** project target 
* wireguard client vpn connection to server 
* all traffic from wireguard clients to tor network
* dns nameresulotion over dnscrypt (Anonymized DNS) with blocklists
* onion (darknet) nameresulotion over dnscrypt forward to tor

## How to install :  
## use the following just for testing 


###### update beta test :) 2022.03.12  Server x86 - debian 11 :
```
wget -O  wireguard-dnscrypt-tor-server-x86.sh https://raw.githubusercontent.com/zzzkeil/wireguard-dnscrypt-tor-server/main/debian_ubuntu/beta_unfinished.sh
chmod +x wireguard-dnscrypt-tor-server-x86.sh
./wireguard-dnscrypt-tor-server-x86.sh
```



