#!/usr/bin/env bash

# enable forwarding from the VPN network
iptables -A FORWARD -i wg0 -o wg0 -j ACCEPT
iptables -A FORWARD -i wg0 -o {{ host_ifname }} -j ACCEPT
iptables -A FORWARD -i {{ host_ifname }} -o wg0 -j ACCEPT
iptables -t nat -A POSTROUTING -o {{ host_ifname }} -j MASQUERADE

# redirect all dns requests from the VPN to the local DNS resolver
iptables -t nat -A PREROUTING -i wg0 -p udp --dport 53 -j DNAT --to-destination {{ vpn_ip }}:55
iptables -t nat -A PREROUTING -i wg0 -p tcp --dport 53 -j DNAT --to-destination {{ vpn_ip }}:55


