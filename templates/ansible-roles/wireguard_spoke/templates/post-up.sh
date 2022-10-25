#!/usr/bin/env bash

iptables -A FORWARD -i wg0 -o {{ host_ifname }} -j ACCEPT
iptables -A FORWARD -i {{ host_ifname }} -o wg0 -j ACCEPT

iptables -t nat -A POSTROUTING -o {{ host_ifname }} -j MASQUERADE

