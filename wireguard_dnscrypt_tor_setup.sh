#!/bin/bash

# visual text settings
RED="\e[31m"
GREEN="\e[32m"
GRAY="\e[37m"
YELLOW="\e[93m"

REDB="\e[41m"
GREENB="\e[42m"
GRAYB="\e[47m"
ENDCOLOR="\e[0m"

clear
echo -e " ${GRAYB}##############################################################################${ENDCOLOR}"
echo -e " ${GRAYB}#${ENDCOLOR} ${GREEN}Wireguard-DNScrypt-TOR-Server setup script for Debian 12 and Fedora 38     ${ENDCOLOR}${GRAYB}#${ENDCOLOR}"
echo -e " ${GRAYB}#${ENDCOLOR} ${GREEN}My base_setup script is needed to install, if not installed this script    ${ENDCOLOR}${GRAYB}#${ENDCOLOR}"
echo -e " ${GRAYB}#${ENDCOLOR} ${GREEN}will automatically download the script, you need to run this manualy       ${ENDCOLOR}${GRAYB}#${ENDCOLOR}"
echo -e " ${GRAYB}#${ENDCOLOR} ${GREEN}More information: https://github.com/zzzkeil/Wireguard-DNScrypt-VPN-Server ${ENDCOLOR}${GRAYB}#${ENDCOLOR}"
echo -e " ${GRAYB}##############################################################################${ENDCOLOR}"
echo -e " ${GRAYB}#${ENDCOLOR}   Version comming soon for debian fedora  x86 and arm64                ${GRAYB}#${ENDCOLOR}"
echo -e " ${GRAYB}##############################################################################${ENDCOLOR}"
echo ""
echo ""
echo ""
echo  -e "                    ${GREEN}To EXIT this script press any key${ENDCOLOR}"
echo ""
echo  -e "                            ${RED}DO NOT RUN THIS SCRIPT NOW !!!!! ____   Press [Y] to begin${ENDCOLOR}"
read -p "" -n 1 -r
echo ""
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

### root check
if [[ "$EUID" -ne 0 ]]; then
	echo -e "${RED}Sorry, you need to run this as root${ENDCOLOR}"
	exit 1
fi

#
# OS check
#
echo -e "${GREEN}OS check ${ENDCOLOR}"

. /etc/os-release

if [[ "$ID" = 'debian' ]]; then
 if [[ "$VERSION_ID" = '12' ]]; then
   echo -e "${GREEN}OS = Debian ${ENDCOLOR}"
   systemos=debian
   fi
fi


if [[ "$ID" = 'fedora' ]]; then
 if [[ "$VERSION_ID" = '38' ]]; then
   echo -e "${GREEN}OS = Fedora ${ENDCOLOR}"
   systemos=fedora
   fi
fi


if [[ "$systemos" = '' ]]; then
   clear
   echo ""
   echo ""
   echo -e "${RED}This script is only for Debian 12 / 11 or Fedora 38 / 37  !${ENDCOLOR}"
   exit 1
fi

#
# Architecture check for dnsscrpt 
#
ARCH=$(uname -m)
if [[ "$ARCH" == x86_64* ]]; then
  dnsscrpt_arch=x86_64
elif [[ "$ARCH" == aarch64* ]]; then
    dnsscrpt_arch=arm64
else
   echo -e "${RED}This script is only for x86_64 or ARM64  Architecture !${ENDCOLOR}"
   exit 1
fi
echo -e "${GREEN}Arch = $dnsscrpt_arch ${ENDCOLOR}"


### base_setup check
if [[ -e /root/base_setup.README ]]; then
     echo -e "base_setup script installed = ${GREEN}ok${ENDCOLOR}"
	 else
	 echo -e " ${YELLOW}Warning:${ENDCOLOR}"
	 echo -e " ${YELLOW}You need to install my base_setup script first!${ENDCOLOR}"
	 echo -e " ${YELLOW}Starting download base_setup.sh from my repository${ENDCOLOR}"
	 echo ""
	 echo ""
	 wget -O  base_setup.sh https://raw.githubusercontent.com/zzzkeil/base_setups/master/base_setup.sh
         chmod +x base_setup.sh
	 echo ""
	 echo ""
         echo -e " Now run ${YELLOW}./base_setup.sh${ENDCOLOR} manualy and reboot, then run this script again."
	 echo ""
	 echo ""
	 exit 1
fi


### script already installed check
if [[ -e /root/Wireguard-DNScrypt-VPN-Server.README ]]; then
     echo
	 echo
         echo -e "${YELLOW}Looks like this script is already installed${ENDCOLOR}"
	 echo -e "${YELLOW}This script is only need for the first install${ENDCOLOR}"
	 echo ""
	 echo "To add or remove clients run"
         echo -e " ${YELLOW}./add_client.sh${ENDCOLOR} to add clients"
         echo -e " ${YELLOW}./remove_client.sh${ENDCOLOR} to remove clients"
	 echo ""
	 echo  "To backup or restore your settings run"
	 echo -e " ${YELLOW}./wg_config_backup.sh${ENDCOLOR} "
	 echo -e " ${YELLOW}./wg_config_restore.sh${ENDCOLOR}"
	 echo ""
	 echo  "To uninstall run"
	 echo -e " ${RED}./uninstaller_back_to_base.sh${ENDCOLOR} "
	 echo ""
	 echo "For - News / Updates / Issues - check my github site"
	 echo "https://github.com/zzzkeil/Wireguard-DNScrypt-VPN-Server"
	 echo
	 echo
	 exit 1
fi


### options
echo ""
echo ""
echo -e " -- Your turn, make a decision -- "
echo ""
echo ""
echo ""
echo -e "${GREEN}Press any key for default port and ip and settings ${ENDCOLOR}"
echo "or"
echo -e "${RED}Press [Y] to change default port; ip; MTU; keepalive (advanced user)${ENDCOLOR}"
echo ""
read -p "" -n 1 -r

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
wg0port=51820
wg0networkv4=66.66
wg0networkv6=66:66:66
wg0mtu="#MTU = 1420"
wg0keepalive="#PersistentKeepalive = 25"
else
echo ""
echo " Wireguard port settings :"
echo "--------------------------------------------------------------------------------------------------------"
read -p "Port: " -e -i 51820 wg0port
echo "--------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------"
echo " Wireguard ipv4 settings :"
echo -e " Format prefix=10. suffix=.1 you can change the green value. eg. 10.${GREEN}66.66${ENDCOLOR}.1"
echo " If you not familiar with ipv4 address scheme, do not change the defaults and press [ENTER]."
echo "--------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------"
read -p "clients ipv4 network: " -e -i 66.66 wg0networkv4
echo "--------------------------------------------------------------------------------------------------------"
echo " Wireguard ipv6 settings :"
echo -e " Format prefix=fd42: suffix=::1 you can change the green value. eg. fd42:${GREEN}66:66:66${ENDCOLOR}::1"
echo " If you not familiar with ipv6 address scheme, do not change the defaults and press [ENTER]."
echo "--------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------"
read -p "clients ipv6 network: " -e -i 66:66:66 wg0networkv6
echo "--------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------"
echo " Wireguard MTU settings :"
echo -e " If you not familiar with MTU settings, do not change the defaults and press [ENTER] ${GREEN}[default = 1420]${ENDCOLOR}."
echo "--------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------"
read -p "MTU =  " -e -i 1420 wg0mtu02
echo "--------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------"
echo " Wireguard keepalive settings :"
echo -e " If you not familiar with keepalive settings, do not change the defaults and press [ENTER] ${GREEN}[default = 0]${ENDCOLOR}."
echo "--------------------------------------------------------------------------------------------------------"
echo "--------------------------------------------------------------------------------------------------------"
read -p "PersistentKeepalive =  : " -e -i 0 wg0keepalive02
echo "--------------------------------------------------------------------------------------------------------"
wg0mtu="MTU = $wg0mtu02"
wg0keepalive="PersistentKeepalive = $wg0keepalive02"

fi
clear


#
# OS updates
#
echo -e "${GREEN}update upgrade and install ${ENDCOLOR}"

if [[ "$systemos" = 'debian' ]]; then
#Tor repository
echo "
   deb     [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org bookworm main
   deb-src [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org bookworm main
 " > /etc/apt/sources.list.d/tor.list
wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null
#Tor repository
apt update && apt upgrade -y && apt autoremove -y
apt install qrencode python-is-python3 curl apt-transport-https linux-headers-$(uname -r) tor deb.torproject.org-keyring -y
apt install wireguard wireguard-tools -y
fi

if [[ "$systemos" = 'fedora' ]]; then
#Tor repository
echo "
[tor]
name=Tor for Fedora $releasever - $basearch
baseurl=https://rpm.torproject.org/fedora/$releasever/$basearch
enabled=1
gpgcheck=1
gpgkey=https://rpm.torproject.org/fedora/public_gpg.key
cost=100
" > /etc/yum.repos.d/tor.repo
#Tor repository
dnf upgrade --refresh -y && dnf autoremove -y
dnf install qrencode python-is-python3 curl cronie cronie-anacron tor -y
dnf install wireguard-tools -y
fi


### create and download files for configs
echo "
!!! do not delete or modify this file
!!  This file contains values line by line, used for config, backups and restores

--- ip settings
ipv4
$wg0networkv4
ipv6
$wg0networkv6
--- port and misc settings
wg0
$wg0port
$wg0mtu
$wg0keepalive
---

For - News / Updates / Issues - check my gitlab site
https://github.com/zzzkeil/Wireguard-DNScrypt-VPN-Server
" > /root/Wireguard-DNScrypt-VPN-Server.README

### for now a copy form https://github.com/zzzkeil/Wireguard-DNScrypt-VPN-Server/
curl -o add_client.sh https://raw.githubusercontent.com/zzzkeil/Wireguard-DNScrypt-VPN-Server/master/tools/add_client.sh
curl -o remove_client.sh https://raw.githubusercontent.com/zzzkeil/Wireguard-DNScrypt-VPN-Server/master/tools/remove_client.sh
curl -o wg_config_backup.sh https://raw.githubusercontent.com/zzzkeil/Wireguard-DNScrypt-VPN-Server/master/tools/wg_config_backup.sh
curl -o wg_config_restore.sh https://raw.githubusercontent.com/zzzkeil/Wireguard-DNScrypt-VPN-Server/master/tools/wg_config_restore.sh
curl -o uninstaller_back_to_base.sh https://raw.githubusercontent.com/zzzkeil/Wireguard-DNScrypt-VPN-Server/master/tools/uninstaller_back_to_base.sh

chmod +x add_client.sh
chmod +x remove_client.sh
chmod +x wg_config_backup.sh
chmod +x wg_config_restore.sh
chmod +x uninstaller_back_to_base.sh



### setup ufw and sysctl

### setup firewalld and sysctl
hostipv4=$(hostname -I | awk '{print $1}')
#i try to disable ipv6 hostipv6=$(hostname -I | awk '{print $2}')

firewall-cmd --zone=public --add-port="$wg0port"/udp

firewall-cmd --zone=trusted --add-source=10.$wg0networkv4.0/24
firewall-cmd --direct --add-rule ipv4 nat POSTROUTING 0 -s 10.$wg0networkv4.0/24 ! -d 10.$wg0networkv4.0/24 -j SNAT --to "$hostipv4"

#i try to disable ipv6 if [[ -n "$hostipv6" ]]; then
#i try to disable ipv6 firewall-cmd --zone=trusted --add-source=fd42:$wg0networkv6::/64
#i try to disable ipv6 firewall-cmd --direct --add-rule ipv6 nat POSTROUTING 0 -s fd42:$wg0networkv6::/64 ! -d fd42:$wg0networkv6::/64 -j SNAT --to "$hostipv6"
fi

firewall-cmd --zone=trusted --add-forward-port=port=53:proto=tcp:toport=53:toaddr=127.0.0.1
firewall-cmd --zone=trusted --add-forward-port=port=53:proto=udp:toport=53:toaddr=127.0.0.1

firewall-cmd --runtime-to-permanent

echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/99-wireguard_ip_forward.conf
#i try to disable ipv6 echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.d/99-wireguard_ip_forward.conf

echo 1 > /proc/sys/net/ipv4/ip_forward
#i try to disable ipv6 echo 1 > /proc/sys/net/ipv6/conf/all/forwarding

#### not working 4 now
inet=$(ip route show default | awk '/default/ {print $5}')
echo "
net.ipv6.conf.$inet.disable_ipv6 = 1
net.ipv6.conf.wg0.disable_ipv6 = 1
" >> /etc/sysctl.conf


### setup wireguard keys and configs
mkdir /etc/wireguard/keys
chmod 700 /etc/wireguard/keys

touch /etc/wireguard/keys/server0
chmod 600 /etc/wireguard/keys/server0
wg genkey > /etc/wireguard/keys/server0
wg pubkey < /etc/wireguard/keys/server0 > /etc/wireguard/keys/server0.pub

touch /etc/wireguard/keys/client1
chmod 600 /etc/wireguard/keys/client1
wg genkey > /etc/wireguard/keys/client1
wg pubkey < /etc/wireguard/keys/client1 > /etc/wireguard/keys/client1.pub

touch /etc/wireguard/keys/client2
chmod 600 /etc/wireguard/keys/client2
wg genkey > /etc/wireguard/keys/client2
wg pubkey < /etc/wireguard/keys/client2 > /etc/wireguard/keys/client2.pub

touch /etc/wireguard/keys/client3
chmod 600 /etc/wireguard/keys/client3
wg genkey > /etc/wireguard/keys/client3
wg pubkey < /etc/wireguard/keys/client3 > /etc/wireguard/keys/client3.pub


echo "[Interface]
Address = 10.$wg0networkv4.1/24
ListenPort = $wg0port
PrivateKey = SK01
# client1
[Peer]
PublicKey = PK01
AllowedIPs = 10.$wg0networkv4.11/32
# client2
[Peer]
PublicKey = PK02
AllowedIPs = 10.$wg0networkv4.12/32
# client3
[Peer]
PublicKey = PK03
AllowedIPs = 10.$wg0networkv4.13/32
# -end of default clients
" > /etc/wireguard/wg0.conf

sed -i "s@SK01@$(cat /etc/wireguard/keys/server0)@" /etc/wireguard/wg0.conf
sed -i "s@PK01@$(cat /etc/wireguard/keys/client1.pub)@" /etc/wireguard/wg0.conf
sed -i "s@PK02@$(cat /etc/wireguard/keys/client2.pub)@" /etc/wireguard/wg0.conf
sed -i "s@PK03@$(cat /etc/wireguard/keys/client3.pub)@" /etc/wireguard/wg0.conf
chmod 600 /etc/wireguard/wg0.conf

echo "[Interface]
Address = 10.$wg0networkv4.11/32
PrivateKey = CK01
DNS = 10.$wg0networkv4.1
$wg0mtu
[Peer]
Endpoint = IP01:$wg0port
PublicKey = SK01
AllowedIPs = 0.0.0.0/0, ::/0
$wg0keepalive
" > /etc/wireguard/client1.conf
sed -i "s@CK01@$(cat /etc/wireguard/keys/client1)@" /etc/wireguard/client1.conf
sed -i "s@SK01@$(cat /etc/wireguard/keys/server0.pub)@" /etc/wireguard/client1.conf
sed -i "s@IP01@$(hostname -I | awk '{print $1}')@" /etc/wireguard/client1.conf
chmod 600 /etc/wireguard/client1.conf

echo "[Interface]
Address = 10.$wg0networkv4.12/32
PrivateKey = CK02
DNS = 10.$wg0networkv4.1
$wg0mtu
[Peer]
Endpoint = IP01:$wg0port
PublicKey = SK01
AllowedIPs = 0.0.0.0/0, ::/0
$wg0keepalive
" > /etc/wireguard/client2.conf
sed -i "s@CK02@$(cat /etc/wireguard/keys/client2)@" /etc/wireguard/client2.conf
sed -i "s@SK01@$(cat /etc/wireguard/keys/server0.pub)@" /etc/wireguard/client2.conf
sed -i "s@IP01@$(hostname -I | awk '{print $1}')@" /etc/wireguard/client2.conf
chmod 600 /etc/wireguard/client2.conf

echo "[Interface]
Address = 10.$wg0networkv4.13/32
PrivateKey = CK03
DNS = 10.$wg0networkv4.1
$wg0mtu
[Peer]
Endpoint = IP01:$wg0port
PublicKey = SK01
AllowedIPs = 0.0.0.0/0, ::/0
$wg0keepalive
" > /etc/wireguard/client3.conf
sed -i "s@CK03@$(cat /etc/wireguard/keys/client3)@" /etc/wireguard/client3.conf
sed -i "s@SK01@$(cat /etc/wireguard/keys/server0.pub)@" /etc/wireguard/client3.conf
sed -i "s@IP01@$(hostname -I | awk '{print $1}')@" /etc/wireguard/client3.conf
chmod 600 /etc/wireguard/client3.conf


#

### setup tor
cp /etc/tor/torrc /root/script_backupfiles/torrc.orig
rm /etc/tor/torrc
echo "
  VirtualAddrNetworkIPv4 172.16.0.0/12
  AutomapHostsOnResolve 1
  AutomapHostsSuffixes .onion
  DNSPort 10.$wg0networkv4.1:53530
  TransPort 10.$wg0networkv4.1:9040
  " > /etc/tor/torrc



###setup DNSCrypt
mkdir /etc/dnscrypt-proxy/
wget -O /etc/dnscrypt-proxy/dnscrypt-proxy.tar.gz https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/2.1.4/dnscrypt-proxy-linux_$dnsscrpt_arch-2.1.4.tar.gz
tar -xvzf /etc/dnscrypt-proxy/dnscrypt-proxy.tar.gz -C /etc/dnscrypt-proxy/
mv -f /etc/dnscrypt-proxy/linux-$dnsscrpt_arch/* /etc/dnscrypt-proxy/
cp /etc/dnscrypt-proxy/example-blocked-names.txt /etc/dnscrypt-proxy/blocklist.txt


exit
###############################################   todo stats here    ###############################################



#curl -o /etc/dnscrypt-proxy/dnscrypt-proxy.toml https://raw.githubusercontent.com/zzzkeil/Wireguard-DNScrypt-VPN-Server/master/tools/dnscrypt-proxy.toml
#curl -o /etc/dnscrypt-proxy/dnscrypt-proxy.toml https://raw.githubusercontent.com/zzzkeil/wireguard-dnscrypt-tor-server/main/configs/dnscrypt-proxy.toml

#curl -o /etc/dnscrypt-proxy/dnscrypt-proxy-update.sh https://raw.githubusercontent.com/zzzkeil/Wireguard-DNScrypt-VPN-Server/master/tools/dnscrypt-proxy-update.sh
#curl -o /etc/dnscrypt-proxy/dnscrypt-proxy-update.sh https://raw.githubusercontent.com/zzzkeil/wireguard-dnscrypt-tor-server/main/configs/dnscrypt-proxy-update.sh

chmod +x /etc/dnscrypt-proxy/dnscrypt-proxy-update.sh

sed -i "s/0.0.0.0/10.$wg0networkv4.1/" /etc/dnscrypt-proxy/dnscrypt-proxy.toml



### setup .onion access
cp /etc/dnscrypt-proxy/example-forwarding-rules.txt /etc/dnscrypt-proxy/forwarding-rules.txt
echo "
onion 10.$wg0networkv4.1:53530
" >> /etc/dnscrypt-proxy/forwarding-rules.txt


### setup blocklist (url & ips) and a allowlist from (anudeepND)"
### !!! this configs files linked to my Wireguard-DNScrypt-VPN-Server repository !!!
mkdir /etc/dnscrypt-proxy/utils/
mkdir /etc/dnscrypt-proxy/utils/generate-domains-blocklists/
curl -o /etc/dnscrypt-proxy/utils/generate-domains-blocklists/domains-blocklist.conf https://raw.githubusercontent.com/zzzkeil/Wireguard-DNScrypt-VPN-Server/master/blocklist/domains-blocklist-default.conf
curl -o /etc/dnscrypt-proxy/utils/generate-domains-blocklists/domains-blocklist-local-additions.txt https://raw.githubusercontent.com/jedisct1/dnscrypt-proxy/master/utils/generate-domains-blocklist/domains-blocklist-local-additions.txt
curl -o /etc/dnscrypt-proxy/utils/generate-domains-blocklists/domains-time-restricted.txt https://raw.githubusercontent.com/jedisct1/dnscrypt-proxy/master/utils/generate-domains-blocklist/domains-time-restricted.txt
curl -o /etc/dnscrypt-proxy/utils/generate-domains-blocklists/domains-allowlist.txt https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt
# old curl -o /etc/dnscrypt-proxy/utils/generate-domains-blacklists/generate-domains-blacklist.py https://raw.githubusercontent.com/jedisct1/dnscrypt-proxy/master/utils/generate-domains-blacklists/generate-domains-blacklist.py
curl -o /etc/dnscrypt-proxy/utils/generate-domains-blocklists/generate-domains-blocklist.py https://raw.githubusercontent.com/DNSCrypt/dnscrypt-proxy/master/utils/generate-domains-blocklist/generate-domains-blocklist.py
chmod +x /etc/dnscrypt-proxy/utils/generate-domains-blocklists/generate-domains-blocklist.py
cd /etc/dnscrypt-proxy/utils/generate-domains-blocklists/
nano /etc/dnscrypt-proxy/utils/generate-domains-blocklists/domains-blocklist.conf
./generate-domains-blocklist.py > /etc/dnscrypt-proxy/blocklist.txt
cd
### setup your allowlist
curl -o /etc/dnscrypt-proxy/allowed-names.txt https://raw.githubusercontent.com/zzzkeil/Wireguard-DNScrypt-VPN-Server/master/blocklist/domains-allowed-names.txt
nano /etc/dnscrypt-proxy/allowed-names.txt
## check if generate blocklist failed - file is empty
curl -o /etc/dnscrypt-proxy/checkblocklist.sh https://raw.githubusercontent.com/zzzkeil/Wireguard-DNScrypt-VPN-Server/master/configs/checkblocklist.sh
chmod +x /etc/dnscrypt-proxy/checkblocklist.sh

curl -o /etc/dnscrypt-proxy/blockedlist-ips.txt https://iplists.firehol.org/files/yoyo_adservers.ipset

### create crontabs
(crontab -l ; echo "50 23 * * 4 cd /etc/dnscrypt-proxy/utils/generate-domains-blocklists/ &&  ./generate-domains-blocklist.py > /etc/dnscrypt-proxy/blocklists.txt") | sort - | uniq - | crontab -
(crontab -l ; echo "30 23 * * 4 curl -o /etc/dnscrypt-proxy/blockedlist-ips.txt https://iplists.firehol.org/files/yoyo_adservers.ipset") | sort - | uniq - | crontab -
(crontab -l ; echo "40 23 * * 4 curl -o /etc/dnscrypt-proxy/utils/generate-domains-blocklists/domains-allowlist.txt https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt") | sort - | uniq - | crontab -
(crontab -l ; echo "15 * * * 5 cd /etc/dnscrypt-proxy/ &&  ./etc/dnscrypt-proxy/checkblocklist.sh") | sort - | uniq - | crontab -
(crontab -l ; echo "59 23 * * 4,5 /bin/systemctl restart dnscrypt-proxy.service") | sort - | uniq - | crontab -
(crontab -l ; echo "59 23 * * 6 /etc/dnscrypt-proxy/dnscrypt-proxy-update.sh") | sort - | uniq - | crontab -



#
### setup systemctl
#systemctl stop systemd-resolved
#systemctl disable systemd-resolved
#cp /etc/resolv.conf /etc/resolv.conf.orig
#rm -f /etc/resolv.conf
systemctl enable wg-quick@wg0.service
systemctl start wg-quick@wg0.service
/etc/dnscrypt-proxy/dnscrypt-proxy -service install
/etc/dnscrypt-proxy/dnscrypt-proxy -service start
systemctl enable tor
systemctl restart tor


### finish
clear
echo ""
echo ""
echo -e "${YELLOW}QR Code for client1.conf${ENDCOLOR}"
echo ""
qrencode -t ansiutf8 < /etc/wireguard/client1.conf
echo ""
echo -e "${YELLOW}Scan the QR Code with your Wiregard App${ENDCOLOR}"
qrencode -o /etc/wireguard/client1.png < /etc/wireguard/client1.conf
qrencode -o /etc/wireguard/client2.png < /etc/wireguard/client2.conf
qrencode -o /etc/wireguard/client3.png < /etc/wireguard/client3.conf
echo ""
echo " 2 extra client configs with QR Codes created in folder : /etc/wireguard/"
echo ""
echo -e " add or remove clients with ${YELLOW}./add_client.sh / remove_client.sh${ENDCOLOR}"
echo ""
echo -e " backup and restore options with ${YELLOW}./wg_config_backup.sh / ./wg_config_restore.sh${ENDCOLOR}"
echo ""
ln -s /etc/wireguard/ /root/wireguard_folder
ln -s /etc/dnscrypt-proxy/ /root/dnscrypt-proxy_folder
ln -s /var/log /root/system-log_folder
ufw --force enable
ufw reload
exit
