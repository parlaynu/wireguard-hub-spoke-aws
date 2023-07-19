## render the run script

resource "local_file" "run_playbook" {
  content = templatefile("templates/ansible/run-ansible.sh.tpl", {
      inventory_file = "inventory.ini"
    })
  filename = "local/ansible/run-ansible.sh"
  file_permission = "0755"
}


## render the playbook

resource "local_file" "playbook" {
  content = templatefile("templates/ansible/playbook.yml.tpl", {
      gateway_role = local.gateway_role,
      iptables_role = local.iptables_role,
      stubby_role = local.stubby_role,
      wireguard_hub_role = local.wireguard_hub_role,
      wireguard_spoke_role = local.wireguard_spoke_role,
    })
  filename = "local/ansible/playbook.yml"
}


## render host variables

resource "local_file" "hostvars_hub" {

  content = templatefile("templates/ansible/hostvars_hub.yml.tpl", {
    host_name      = var.hub_name,
    host_ifname    = var.hub_instance_ifname
    public_ip        = aws_instance.hub.public_ip,
    private_ip       = aws_instance.hub.private_ip
    cidr_block       = aws_vpc.hub.cidr_block

    vpn_cidr_block   = var.vpn_cidr_block
    vpn_netlen       = split("/", var.vpn_cidr_block)[1]
    vpn_ip           = local.vpn_hub_ip
    vpn_port         = var.vpn_port
    vpn_private_key  = wireguard_asymmetric_key.vpn_hub.private_key,
    
    stubby_upstream = var.hub_stubby_upstream_servers

    spokes = [for key, value in var.spokes :
        {
          name = key
          vpn_ip  = local.vpn_spoke_ips[key],
          vpn_public_key = wireguard_asymmetric_key.vpn_spokes[key].public_key
          local_networks = [for net in value.local_networks: net]
        }
      ]
    })

  filename        = "local/ansible/host_vars/${var.hub_name}.yml"
  file_permission = "0640"
}


resource "local_file" "hostvars_spoke" {
  for_each = var.spokes

  content = templatefile("templates/ansible/hostvars_spoke.yml.tpl", {
    host_name = each.key
    host_ifname = each.value.ifname
    host_ip = each.value.access_ip
    local_networks = each.value.local_networks
    
    vpn_cidr_block = var.vpn_cidr_block,
    vpn_netlen = split("/", var.vpn_cidr_block)[1],
    vpn_ip = local.vpn_spoke_ips[each.key],
    vpn_private_key = wireguard_asymmetric_key.vpn_spokes[each.key].private_key,
    vpn_keepalive_interval = each.value.keepalive_interval

    vpn_hub_endpoint = aws_instance.hub.public_ip,
    vpn_hub_port = var.vpn_port,
    vpn_hub_public_key = wireguard_asymmetric_key.vpn_hub.public_key,
  })

  filename        = "local/ansible/host_vars/${each.key}.yml"
  file_permission = "0640"
}


## render the inventory file

resource "local_file" "inventory" {
  content = templatefile("templates/ansible/inventory.ini.tpl", {
    hub_name = var.hub_name,
    spoke_names = keys(var.spokes)
    })
  filename = "local/ansible/inventory.ini"
  file_permission = "0640"
}

