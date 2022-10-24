#!/usr/bin/env bash

# disable forwarding from the vpn interface
iptables -D FORWARD -i wg0 -o wg0 -j ACCEPT
iptables -D FORWARD -i wg0 -o {{ host_ifname }} -j ACCEPT
iptables -D FORWARD -i {{ host_ifname }} -o wg0 -j ACCEPT
iptables -t nat -D POSTROUTING -o {{ host_ifname }} -j MASQUERADE

# dnsable DNS forwarding
iptables -t nat -D PREROUTING -i wg0 -p udp --dport 53 -j DNAT --to-destination {{ vpn_ip }}:55
iptables -t nat -D PREROUTING -i wg0 -p tcp --dport 53 -j DNAT --to-destination {{ vpn_ip }}:55
