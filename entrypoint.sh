#!/bin/bash

ip route add 192.168/16 dev eth0 metric 5 table 100
ip route add 172.16/12 dev eth0 metric 5 table 100
ip route add prohibit default metric 10 table 100
ip route add blackhole default metric 11 table 100

REMOTE_ADDR=$(cat /config.ovpn | grep "remote " | cut -d " " -f 2)
REMOTE_PORT=$(cat /config.ovpn | grep "remote " | cut -d " " -f 3)

ip rule add not to $REMOTE_ADDR dport $REMOTE_PORT  table 100


rm /etc/airvpn/hummingbird.lock
/usr/bin/hummingbird --recover-network &> /dev/null

touch ./airvpn_log
/usr/bin/hummingbird --persist-tun --network-lock off /config.ovpn &> airvpn_log &

sleep 3

ip route add default dev tun0 metric 5 table 100
echo "nameserver $(grep -oP "(?<=\[DNS\]\s\[)[\d\.]*" airvpn_log)" > /etc/resolv.conf
echo "nameserver $(grep -oP "(?<=\[DNS6\]\s\[)[a-zA-Z\d\:]*" airvpn_log)" >> /etc/resolv.conf

tail -f -n 1000 airvpn_log

