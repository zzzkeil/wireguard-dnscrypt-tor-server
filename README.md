# Wireguard-tor-server gateway
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/Logo_of_WireGuard.svg/320px-Logo_of_WireGuard.svg.png" height="75">   <img src="https://raw.github.com/dnscrypt/dnscrypt-proxy/master/logo.png" height="100"> <img src="https://www.torproject.org/static/images/tor-logo/Color.png" height="90">

![Debian](https://img.shields.io/badge/Debian-D70A53?style=for-the-badge&logo=debian&logoColor=white) ![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white) ![Fedora](https://img.shields.io/badge/Fedora-294172?style=for-the-badge&logo=fedora&logoColor=white) ![Rocky Linux](https://img.shields.io/badge/-Rocky%20Linux-%2310B981?style=for-the-badge&logo=rockylinux&logoColor=white) ![Cent OS](https://img.shields.io/badge/cent%20os-002260?style=for-the-badge&logo=centos&logoColor=F0F0F0) ![Alma Linux](https://img.shields.io/badge/alma%20linux-294172?style=for-the-badge&logo=almalinux&logoColor=F0F0F0)

[![https://hetzner.cloud/?ref=iP0i3O1wRcHu](https://img.shields.io/badge/maybe_you_can_support_me_-_my_VPS_hoster_hetzner_(referral_link)_thanks-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#EA4AAA)](https://hetzner.cloud/?ref=iP0i3O1wRcHu) 

## ** project target 
*  wireguard connection to server 
* all traffic coming from wireguard clients will go over tor network
* dns nameresulotion over dnscrypt (Anonymized DNS) with blocklists
* onion (darknet) nameresulotion over dnscrypt forward to tor

## How to install :  
## use the following just for testing 

###### Server x86 / ARM64 - Debian 12, Ubuntu 22.04, Fedora 38, Rocky Linux 9, CentOS Stream 9, AlmaLinux 9:
```
## Testversion : 2023.06.27
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






