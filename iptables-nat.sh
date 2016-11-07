#!/bin/sh

LAN_NIC=ens34
WAN_NIC=ens33

#service iptables stop
iptables -F
iptables -F -t nat


iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP


#LAN_NETMASK=`ifconfig $LAN_NIC | sed -e 's/^.*Mask:\([^ ]*\)$/\1/p' -e d`
#LAN_NETADDR=`netstat -rn | grep $LAN_NIC | grep $LAN_NETMASK | awk '{print $1}'`
LAN_NETMASK=255.255.255.0
LAN_NETADDR=192.168.202.0


iptables -t nat -A POSTROUTING -o $WAN_NIC -s $LAN_NETADDR/$LAN_NETMASK -j MASQUERADE
# iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
# iptables -A FORWARD -i $LAN_NIC -o $WAN_NIC -j ACCEPT


iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -s 127.0.0.0/8 -j ACCEPT

iptables -A INPUT -i $LAN_NIC -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -A FORWARD -i $LAN_NIC -j ACCEPT
iptables -A FORWARD -i lo -j ACCEPT
iptables -A FORWARD -s 127.0.0.0/8 -j ACCEPT
iptables -A FORWARD -s 172.17.0.0/16 -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT



#iptables -A OUTPUT -o $WAN_NIC -d 127.0.0.0/8 -j DROP
#iptables -A OUTPUT -o $WAN_NIC -d 10.0.0.0/8 -j DROP
#iptables -A OUTPUT -o $WAN_NIC -d 172.16.0.0/12 -j DROP
#iptables -A OUTPUT -o $WAN_NIC -d 192.168.0.0/16 -j DROP


#service iptables save
#service iptables start
