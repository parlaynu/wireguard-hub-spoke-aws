#!/usr/bin/env bash

iptables -A FORWARD -i wg0 -o {{ host_ifname }}  -j ACCEPT
iptables -A FORWARD -o wg0 -i {{ host_ifname }}  -j ACCEPT

iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE

ip route add {{ vpn_server_endpoint }}/32 via 192.168.24.1 dev {{ host_ifname }} 
ip route add 0.0.0.0/1 via 192.168.33.1 dev wg0
ip route add 128.0.0.0/1 via 192.168.33.1 dev wg0

