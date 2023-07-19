---
host_name: ${host_name}
host_ifname: ${host_ifname}
public_ip: ${public_ip}
private_ip: ${private_ip}
cidr_block: ${cidr_block}

vpn_cidr_block: ${vpn_cidr_block}
vpn_ip: ${vpn_ip}
vpn_port: ${vpn_port}
vpn_netlen: ${vpn_netlen}
vpn_private_key: ${vpn_private_key}

spokes:
%{ for spoke in spokes ~}
- name: ${spoke.name}
  vpn_ip: ${spoke.vpn_ip}
  vpn_public_key: ${spoke.vpn_public_key}
  local_networks:
%{for net in spoke.local_networks ~}
  - ${net}
%{ endfor ~}
%{ endfor ~}

stubby_upstream_servers:
%{ for upstream in stubby_upstream ~}
- ip_address: ${upstream.ip_address}
  tls_auth_name: ${upstream.tls_auth_name}
%{ endfor ~}

