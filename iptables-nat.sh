#!/bin/sh

wan_nic=${external_nic}
wan_net=$(ip -4 -o a show ${wan_nic} | awk '{sub(/\d+\//, "0/",$4); print $4}')

#service iptables stop
iptables -F
iptables -F -t nat


iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP


iptables -t nat -A POSTROUTING -o $wan_nic ! -s $wan_net -j MASQUERADE

iptables -A FORWARD ! -i $wan_nic -j ACCEPT
iptables -A FORWARD -i lo -j ACCEPT
iptables -A FORWARD -s 127.0.0.0/8 -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
