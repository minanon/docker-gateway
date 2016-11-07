external_nic=$(ip -4 -o a | grep -v ': lo' | cut -f2 -d' ')

source /iptabls.sh
