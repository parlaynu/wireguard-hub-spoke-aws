#!/usr/bin/env bash

# disable forwarding from the vpn interface
iptables -D FORWARD -i wg0 -o {{ server_ifname }} -j ACCEPT
iptables -D FORWARD -o wg0 -i {{ server_ifname }} -j ACCEPT
iptables -t nat -D POSTROUTING -o {{ server_ifname }} -j MASQUERADE

# dnsable DNS forwarding
iptables -t nat -D PREROUTING -i wg0 -p udp --dport 53 -j DNAT --to-destination {{ vpn_ip }}:55
iptables -t nat -D PREROUTING -i wg0 -p tcp --dport 53 -j DNAT --to-destination {{ vpn_ip }}:55
