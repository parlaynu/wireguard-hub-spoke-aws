#!/usr/bin/env bash

iptables -D FORWARD -i wg0 -o {{ host_ifname }} -j ACCEPT
iptables -D FORWARD -i {{ host_ifname }} -o wg0 -j ACCEPT

iptables -t nat -D POSTROUTING -o {{ host_ifname }} -j MASQUERADE

