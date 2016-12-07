#!/bin/sh

/iptables-nat.sh

exec tail -f /etc/hosts
