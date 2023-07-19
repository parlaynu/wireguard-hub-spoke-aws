---
host_name: ${host_name}
host_ifname: ${host_ifname}
public_ip: ${host_ip}

vpn_cidr_block: ${vpn_cidr_block}
vpn_netlen: ${vpn_netlen}
vpn_ip: ${vpn_ip}
vpn_private_key: ${vpn_private_key}
vpn_keepalive_interval: ${vpn_keepalive_interval}

vpn_hub_endpoint: ${vpn_hub_endpoint}
vpn_hub_port: ${vpn_hub_port}
vpn_hub_public_key: ${vpn_hub_public_key}

local_networks:
%{ for network in local_networks ~}
- ${network}
%{ endfor ~}

