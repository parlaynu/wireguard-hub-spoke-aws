#!/usr/bin/env bash

iptables -D FORWARD -i wg0 -o {{ host_ifname }}  -j ACCEPT
iptables -D FORWARD -o wg0 -i {{ host_ifname }}  -j ACCEPT

iptables -t nat -D POSTROUTING -o wg0 -j MASQUERADE

ip route del 0.0.0.0/1 via 192.168.33.1 dev wg0
ip route del 128.0.0.0/1 via 192.168.33.1 dev wg0
ip route del {{ vpn_server_endpoint }}/32 via 192.168.24.1 dev {{ host_ifname }} 
