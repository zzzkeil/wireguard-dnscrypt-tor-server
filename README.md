# Wireguard-tor-server gateway
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/Logo_of_WireGuard.svg/320px-Logo_of_WireGuard.svg.png" height="75">   <img src="https://raw.github.com/dnscrypt/dnscrypt-proxy/master/logo.png" height="100"> <img src="https://www.torproject.org/static/images/tor-logo/Color.png" height="90">

![Debian](https://img.shields.io/badge/Debian-D70A53?style=for-the-badge&logo=debian&logoColor=white) ![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)

[![https://hetzner.cloud/?ref=iP0i3O1wRcHu](https://img.shields.io/badge/maybe_you_can_support_me_-_my_VPS_hoster_hetzner_(referral_link)_thanks-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://hetzner.cloud/?ref=iP0i3O1wRcHu) 

## ** project target 
*  wireguard connection to server 
* all traffic coming from wireguard clients will go over tor network
* dns nameresulotion over dnscrypt (Anonymized DNS) with blocklists
* onion (darknet) nameresulotion over dnscrypt forward to tor

## How to install :  
## use the following just for testing 

###### Server x86 / ARM64 - Debian 12, Ubuntu 22.04 :
```
## Testversion : 2023.07.01 -  some issuse with fedora, centos, rocky-linux, alma-linux -- removed 
wget -O  wireguard_dnscrypt_tor_setup.sh https://raw.githubusercontent.com/zzzkeil/wireguard-dnscrypt-tor-server/main/wireguard_dnscrypt_tor_setup.sh
chmod +x wireguard_dnscrypt_tor_setup.sh
./wireguard_dnscrypt_tor_setup.sh
```





#### status 2023.06.12 : 

** whats working :  
* wireguard
* dnscrypt
* tor
* blocklist...

( some issues with .onion have to be fixed )






