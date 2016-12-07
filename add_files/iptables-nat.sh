#!/bin/sh

# external network setting
wan_nic=$(ip -4 -o a | grep -v ': lo' | head -n1 | cut -f2 -d' ')
wan_net=$(ip -4 -o a show ${wan_nic} | awk '{sub(/\d+\//, "0/",$4); print $4}')


# iptables setting
# init
iptables -F
iptables -F -t nat

# policy
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

# nat
iptables -t nat -A POSTROUTING -o $wan_nic ! -s $wan_net -j MASQUERADE

# limit input
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# limit forward
iptables -A FORWARD ! -i $wan_nic -j ACCEPT
iptables -A FORWARD -i lo -j ACCEPT
iptables -A FORWARD -s 127.0.0.0/8 -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
