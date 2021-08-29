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
echo -e " ${GRAYB}#${ENDCOLOR} ${GREEN}Wireguard-DNScrypt-TOR-Server setup script for Ubuntu 18.04 and above      ${ENDCOLOR}${GRAYB}#${ENDCOLOR}"
echo -e " ${GRAYB}#${ENDCOLOR} ${GREEN}My base_setup script is needed to install, if not installed this script    ${ENDCOLOR}${GRAYB}#${ENDCOLOR}"
echo -e " ${GRAYB}#${ENDCOLOR} ${GREEN}will automatically download the script, you need to run this manualy       ${ENDCOLOR}${GRAYB}#${ENDCOLOR}"
echo -e " ${GRAYB}#${ENDCOLOR} ${GREEN}More information: https://github.com/zzzkeil/Wireguard-DNScrypt-VPN-Server ${ENDCOLOR}${GRAYB}#${ENDCOLOR}"
echo -e " ${GRAYB}##############################################################################${ENDCOLOR}"
echo -e " ${GRAYB}#${ENDCOLOR}                 Version ${RED}!! not ready to run !!${ENDCOLOR}             ${GRAYB}#${ENDCOLOR}"
echo -e " ${GRAYB}##############################################################################${ENDCOLOR}"
echo ""
echo ""
echo ""
echo  -e "                    ${RED}To EXIT this script press any key${ENDCOLOR}"
echo ""
echo  -e "                            ${GREEN}Press [Y] to begin${ENDCOLOR}"
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

### check if Ubuntu OS 18.04 or 20.04
if [[ -e /etc/os-release ]]; then
      echo -e "/etc/os-release check = ${GREEN}ok${ENDCOLOR}"
      else
      echo "/etc/os-release not found! Maybe no Ubuntu OS ?"
      echo -e "${RED}This script is made for Ubuntu 18.04 / 20.04${ENDCOLOR}"
      exit 1
fi

. /etc/os-release
if [[ "$NAME" = 'Ubuntu' ]]; then
   echo -e "OS Name check = ${GREEN}ok${ENDCOLOR}"
   else 
   echo -e "${RED}This script is made for Ubuntu 18.04 / 20.04${ENDCOLOR}"
   exit 1
fi

if [[ "$VERSION_ID" = '18.04' ]] || [[ "$VERSION_ID" = '20.04' ]]; then
   echo -e "OS Versions check = ${GREEN}ok${ENDCOLOR}"
   else
   echo -e "${RED}Ubuntu Versions below 18.04 not supported - upgrade please, its 2021 :) ${ENDCOLOR}"
   exit 1
fi


### script already installed check
if [[ -e /root/Wireguard-DNScrypt-Tor-Server.README ]]; then
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
	 echo "https://github.com/zzzkeil/wireguard-dnscrypt-tor-server"
	 echo
	 echo
	 exit 1
fi

### options
echo ""
echo ""
echo -e " -- Your turn, make a decision for your wireguard config "
echo ""
echo ""
echo ""
echo -e "${GREEN}Press any key for default port and ip´s and settings (recommended) ${ENDCOLOR}"
echo "or"
echo -e "${RED}Press [Y] to change default port; ip´s; MTU; keepalive (advanced user)${ENDCOLOR}"
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
echo ""
echo -e "${YELLOW}apt systemupdate and installs${ENDCOLOR}"



































echo "
deb https://deb.torproject.org/torproject.org focal main
deb-src https://deb.torproject.org/torproject.org focal main 
" > /etc/apt/sources.list.d/tor.list

curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import
gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -


apt update && apt upgrade -y && apt autoremove -y
apt install qrencode python curl linux-headers-$(uname -r) apt-transport-https -y 
apt install wireguard-dkms wireguard-tools tor deb.torproject.org-keyring -y

### setup ufw and sysctl
inet=$(ip route show default | awk '/default/ {print $5}')
ufw allow $wg0port/udp
#ufw allow proto udp from 0.0.0.0/0 port $wg0port
cp /etc/default/ufw /root/script_backupfiles/ufw.orig
cp /etc/ufw/before.rules /root/script_backupfiles/before.rules.orig
cp /etc/ufw/before6.rules /root/script_backupfiles/before6.rules.orig
sed -i 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw
sed -i '1i# START WIREGUARD RULES\n# NAT table rules\n*nat\n:POSTROUTING ACCEPT [0:0]\n# Allow traffic from WIREGUARD client \n-A POSTROUTING -s 10.8.0.0/24 -o $inet -j MASQUERADE\n-A PREROUTING -i wg0 -p udp --dport 53 -s 10.8.0.0/24 -j DNAT --to-destination 10.8.0.1:5353\n-A PREROUTING -i wg0 -p tcp -s 10.8.0.0/24 -j DNAT --to-destination 10.8.0.1:9040\n-A PREROUTING -i wg0 -p udp -s 10.8.0.0/24 -j DNAT --to-destination 10.8.0.1:9040\nCOMMIT\n# END WIREGUARD RULES\n' /etc/ufw/before.rules
sed -i '/# End required lines/a \\n-A INPUT -i wg0 -s 10.8.0.0/24 -m state --state NEW -j ACCEPT' /etc/ufw/before.rules
sed -i '/-A ufw-before-input -p icmp --icmp-type echo-request -j ACCEPT/a \\n# allow outbound icmp\n-A ufw-before-output -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT\n-A ufw-before-output -p icmp -m state --state ESTABLISHED,RELATED -j ACCEPT\n' /etc/ufw/before.rules
cp /etc/sysctl.conf /root/script_backupfiles/sysctl.conf.orig
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
cp /etc/ufw/sysctl.conf /root/script_backupfiles/sysctl.conf.ufw.orig
sed -i 's@#net/ipv4/ip_forward=1@net/ipv4/ip_forward=1@g' /etc/ufw/sysctl.conf


#### not working 4 now
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

touch /etc/wireguard/keys/client4
chmod 600 /etc/wireguard/keys/client4
wg genkey > /etc/wireguard/keys/client4
wg pubkey < /etc/wireguard/keys/client4 > /etc/wireguard/keys/client4.pub

touch /etc/wireguard/keys/client5
chmod 600 /etc/wireguard/keys/client5
wg genkey > /etc/wireguard/keys/client5
wg pubkey < /etc/wireguard/keys/client5 > /etc/wireguard/keys/client5.pub

### -
echo "[Interface]
Address = 10.8.0.1/24
ListenPort = $wg0port
PrivateKey = SK01
# client1
[Peer]
PublicKey = PK01
AllowedIPs = 10.8.0.11/32
# client2
[Peer]
PublicKey = PK02
AllowedIPs = 10.8.0.12/32
# client3
[Peer]
PublicKey = PK03
AllowedIPs = 10.8.0.13/32
# client4
[Peer]
PublicKey = PK04
AllowedIPs = 10.8.0.14/32
# client5
[Peer]
PublicKey = PK05
AllowedIPs = 10.8.0.15/32
# -end of default clients
" > /etc/wireguard/wg0.conf
sed -i "s@SK01@$(cat /etc/wireguard/keys/server0)@" /etc/wireguard/wg0.conf
sed -i "s@PK01@$(cat /etc/wireguard/keys/client1.pub)@" /etc/wireguard/wg0.conf
sed -i "s@PK02@$(cat /etc/wireguard/keys/client2.pub)@" /etc/wireguard/wg0.conf
sed -i "s@PK03@$(cat /etc/wireguard/keys/client3.pub)@" /etc/wireguard/wg0.conf
sed -i "s@PK04@$(cat /etc/wireguard/keys/client4.pub)@" /etc/wireguard/wg0.conf
sed -i "s@PK05@$(cat /etc/wireguard/keys/client5.pub)@" /etc/wireguard/wg0.conf
chmod 600 /etc/wireguard/wg0.conf

### -
echo "[Interface]
Address = 10.8.0.11/32
PrivateKey = CK01
DNS = 10.8.0.1
[Peer]
Endpoint = IP01:$wg0port
PublicKey = SK01
AllowedIPs = 0.0.0.0/0, ::/0
" > /etc/wireguard/client1.conf
sed -i "s@CK01@$(cat /etc/wireguard/keys/client1)@" /etc/wireguard/client1.conf
sed -i "s@SK01@$(cat /etc/wireguard/keys/server0.pub)@" /etc/wireguard/client1.conf
sed -i "s@IP01@$(hostname -I | awk '{print $1}')@" /etc/wireguard/client1.conf
chmod 600 /etc/wireguard/client1.conf

echo "[Interface]
Address = 10.8.0.12/32
PrivateKey = CK02
DNS = 10.8.0.1
[Peer]
Endpoint = IP01:$wg0port
PublicKey = SK01
AllowedIPs = 0.0.0.0/0, ::/0
" > /etc/wireguard/client2.conf
sed -i "s@CK02@$(cat /etc/wireguard/keys/client2)@" /etc/wireguard/client2.conf
sed -i "s@SK01@$(cat /etc/wireguard/keys/server0.pub)@" /etc/wireguard/client2.conf
sed -i "s@IP01@$(hostname -I | awk '{print $1}')@" /etc/wireguard/client2.conf
chmod 600 /etc/wireguard/client2.conf

echo "[Interface]
Address = 10.8.0.13/32
PrivateKey = CK03
DNS = 10.8.0.1
[Peer]
Endpoint = IP01:$wg0port
PublicKey = SK01
AllowedIPs = 0.0.0.0/0, ::/0
" > /etc/wireguard/client3.conf
sed -i "s@CK03@$(cat /etc/wireguard/keys/client3)@" /etc/wireguard/client3.conf
sed -i "s@SK01@$(cat /etc/wireguard/keys/server0.pub)@" /etc/wireguard/client3.conf
sed -i "s@IP01@$(hostname -I | awk '{print $1}')@" /etc/wireguard/client3.conf
chmod 600 /etc/wireguard/client3.conf

echo "[Interface]
Address = 10.8.0.14/32
PrivateKey = CK04
DNS = 10.8.0.1
[Peer]
Endpoint = IP01:$wg0port
PublicKey = SK01
AllowedIPs = 0.0.0.0/0, ::/0
" > /etc/wireguard/client4.conf
sed -i "s@CK04@$(cat /etc/wireguard/keys/client4)@" /etc/wireguard/client4.conf
sed -i "s@SK01@$(cat /etc/wireguard/keys/server0.pub)@" /etc/wireguard/client4.conf
sed -i "s@IP01@$(hostname -I | awk '{print $1}')@" /etc/wireguard/client4.conf
chmod 600 /etc/wireguard/client4.conf

echo "[Interface]
Address = 10.8.0.15/32
PrivateKey = CK05
DNS = 10.8.0.1
[Peer]
Endpoint = IP01:$wg0port
PublicKey = SK01
AllowedIPs = 0.0.0.0/0, ::/0
" > /etc/wireguard/client5.conf
sed -i "s@CK05@$(cat /etc/wireguard/keys/client5)@" /etc/wireguard/client5.conf
sed -i "s@SK01@$(cat /etc/wireguard/keys/server0.pub)@" /etc/wireguard/client5.conf
sed -i "s@IP01@$(hostname -I | awk '{print $1}')@" /etc/wireguard/client5.conf
chmod 600 /etc/wireguard/client5.conf
#

### setup tor
cp /etc/tor/torrc /root/script_backupfiles/torrc.orig
rm /etc/tor/torrc
echo "
  VirtualAddrNetwork 10.192.0.0/10
  AutomapHostsOnResolve 1
  DNSPort 10.8.0.1:53530
  TransPort 10.8.0.1:9040
  
  " > /etc/tor/torrc


###setup DNSCrypt 
mkdir /etc/dnscrypt-proxy/
wget -O /etc/dnscrypt-proxy/dnscrypt-proxy.tar.gz https://github.com/jedisct1/dnscrypt-proxy/releases/download/2.0.45/dnscrypt-proxy-linux_x86_64-2.0.45.tar.gz
tar -xvzf /etc/dnscrypt-proxy/dnscrypt-proxy.tar.gz -C /etc/dnscrypt-proxy/
mv -f /etc/dnscrypt-proxy/linux-x86_64/* /etc/dnscrypt-proxy/
cp /etc/dnscrypt-proxy/example-blocked-names.txt /etc/dnscrypt-proxy/blocklist.txt
curl -o /etc/dnscrypt-proxy/dnscrypt-proxy.toml https://raw.githubusercontent.com/zzzkeil/wireguard-dnscrypt-tor-server/main/configs/dnscrypt-proxy.toml
curl -o /etc/dnscrypt-proxy/dnscrypt-proxy-update.sh https://raw.githubusercontent.com/zzzkeil/wireguard-dnscrypt-tor-server/main/configs/dnscrypt-proxy-update.sh
chmod +x /etc/dnscrypt-proxy/dnscrypt-proxy-update.sh
#

### setup .onion access
cp /etc/dnscrypt-proxy/example-forwarding-rules.txt /etc/dnscrypt-proxy/forwarding-rules.txt
echo "
onion 10.8.0.1:53530
" >> /etc/dnscrypt-proxy/forwarding-rules.txt

#
### setup blocklist and a allowlist from (anudeepND)"
mkdir /etc/dnscrypt-proxy/utils/
mkdir /etc/dnscrypt-proxy/utils/generate-domains-blocklists/
curl -o /etc/dnscrypt-proxy/utils/generate-domains-blocklists/domains-blocklist.conf https://raw.githubusercontent.com/zzzkeil/wireguard-dnscrypt-tor-server/main/blocklist/domains-blocklist-default.conf
curl -o /etc/dnscrypt-proxy/utils/generate-domains-blocklists/domains-blocklist-local-additions.txt https://raw.githubusercontent.com/jedisct1/dnscrypt-proxy/master/utils/generate-domains-blocklist/domains-blocklist-local-additions.txt
curl -o /etc/dnscrypt-proxy/utils/generate-domains-blocklists/domains-time-restricted.txt https://raw.githubusercontent.com/jedisct1/dnscrypt-proxy/master/utils/generate-domains-blocklist/domains-time-restricted.txt
curl -o /etc/dnscrypt-proxy/utils/generate-domains-blocklists/domains-allowlist.txt https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt
curl -o /etc/dnscrypt-proxy/utils/generate-domains-blocklists/generate-domains-blocklist.py https://raw.githubusercontent.com/DNSCrypt/dnscrypt-proxy/master/utils/generate-domains-blocklist/generate-domains-blocklist.py
chmod +x /etc/dnscrypt-proxy/utils/generate-domains-blocklists/generate-domains-blocklist.py
cd /etc/dnscrypt-proxy/utils/generate-domains-blocklists/
./generate-domains-blocklist.py > /etc/dnscrypt-proxy/blocklist.txt
cd
## check if generate blocklist failed - file is empty
curl -o /etc/dnscrypt-proxy/checkblocklist.sh https://raw.githubusercontent.com/zzzkeil/wireguard-dnscrypt-tor-server/main/configs/checkblocklist.sh
chmod +x /etc/dnscrypt-proxy/checkblocklist.sh
#
### create crontabs
(crontab -l ; echo "50 23 * * 4 cd /etc/dnscrypt-proxy/utils/generate-domains-blocklists/ &&  ./generate-domains-blocklist.py > /etc/dnscrypt-proxy/blocklists.txt") | sort - | uniq - | crontab -
(crontab -l ; echo "40 23 * * 4 curl -o /etc/dnscrypt-proxy/utils/generate-domains-blocklists/domains-allowlist.txt https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt") | sort - | uniq - | crontab -
(crontab -l ; echo "30 23 * * 4 curl -o /etc/dnscrypt-proxy/utils/generate-domains-blocklists/domains-blocklist.conf https://raw.githubusercontent.com/zzzkeil/wireguard-dnscrypt-tor-server/main/blocklist/domains-blocklist-default.conf") | sort - | uniq - | crontab -
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
systemctl restart tor


#
### set file for install check and tools download"
echo "
+++ do not delete this file +++
Instructions coming soon 
For - News / Updates / Issues - check my github site
https://github.com/zzzkeil
" > /root/Wireguard-DNScrypt-Tor-Server.README

#
### finish
clear
echo ""
echo "QR Code for client1.conf "
qrencode -t ansiutf8 < /etc/wireguard/client1.conf
echo "Scan the QR Code with your Wiregard App"
qrencode -o /etc/wireguard/client1.png < /etc/wireguard/client1.conf
qrencode -o /etc/wireguard/client2.png < /etc/wireguard/client2.conf
qrencode -o /etc/wireguard/client3.png < /etc/wireguard/client3.conf
qrencode -o /etc/wireguard/client4.png < /etc/wireguard/client4.conf
qrencode -o /etc/wireguard/client5.png < /etc/wireguard/client5.conf
echo ""
ln -s /etc/dnscrypt-proxy/ /root/dnscrypt-proxy_folder
ln -s /etc/wireguard/ /root/wireguard_folder
ln -s /var/log /root/system-log_folder
ufw --force enable
ufw reload
