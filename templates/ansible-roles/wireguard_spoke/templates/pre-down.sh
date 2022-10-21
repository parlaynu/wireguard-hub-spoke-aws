#!/usr/bin/env bash

iptables -D FORWARD -i wg0 -o {{ host_ifname }}  -j ACCEPT
iptables -D FORWARD -o wg0 -i {{ host_ifname }}  -j ACCEPT

iptables -t nat -D POSTROUTING -o wg0 -j MASQUERADE

ip route del {{ vpn_hub_endpoint }}/32 via {{ host_gateway }} dev {{ host_ifname }} 
ip route del 0.0.0.0/1 via {{ vpn_hub_vpn_ip }} dev wg0
ip route del 128.0.0.0/1 via {{ vpn_hub_vpn_ip }} dev wg0

