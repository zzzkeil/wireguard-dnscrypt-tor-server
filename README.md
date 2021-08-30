# Wireguard-tor-Server 

### Project start 2021.01.24

#### status 2021.08.29 : 
** whats working :  
* wireguard
* dnscrypt
* tor

( some issues with .onion have to be fixed  / not working in this version )


## ** project target 
* wireguard client vpn connection to server 
* all traffic from wireguard clients to tor network
* dns nameresulotion over dnscrypt (Anonymized DNS) with blocklists
* onion (darknet) nameresulotion over dnscrypt forward to tor

## How to install :  
## use the following just for testing 


###### beta test :) 2021.08.29  Server x86 - Ubuntu 20.04 :
```
wget -O  wireguard-dnscrypt-tor-server-x86.sh https://raw.githubusercontent.com/zzzkeil/wireguard-dnscrypt-tor-server/main/ubuntu/beta_unfinished.sh
chmod +x wireguard-dnscrypt-tor-server-x86.sh
./wireguard-dnscrypt-tor-server-x86.sh
```



