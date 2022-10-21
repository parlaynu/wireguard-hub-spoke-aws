#!/usr/bin/env bash

# enable forwarding from the VPN network
iptables -A FORWARD -i wg0 -o {{ server_ifname }} -j ACCEPT
iptables -A FORWARD -o wg0 -i {{ server_ifname }} -j ACCEPT
iptables -t nat -A POSTROUTING -o {{ server_ifname }} -j MASQUERADE

# redirect all dns requests from the VPN to the local DNS resolver
iptables -t nat -A PREROUTING -i wg0 -p udp --dport 53 -j DNAT --to-destination {{ vpn_ip }}:55
iptables -t nat -A PREROUTING -i wg0 -p tcp --dport 53 -j DNAT --to-destination {{ vpn_ip }}:55


