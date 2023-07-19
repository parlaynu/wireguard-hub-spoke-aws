locals {
  gateway_role = "gateway"
  iptables_role = "iptables"
  stubby_role = "stubby"
  wireguard_hub_role = "wireguard_hub"
  wireguard_spoke_role = "wireguard_spoke"
}

resource "template_dir" "gateway" {
  source_dir      = "templates/ansible-roles/${local.gateway_role}"
  destination_dir = "local/ansible/roles/${local.gateway_role}"

  vars = {}
}

resource "template_dir" "iptables" {
  source_dir      = "templates/ansible-roles/${local.iptables_role}"
  destination_dir = "local/ansible/roles/${local.iptables_role}"

  vars = {}
}

resource "template_dir" "stubby" {
  source_dir      = "templates/ansible-roles/${local.stubby_role}"
  destination_dir = "local/ansible/roles/${local.stubby_role}"

  vars = {}
}

resource "template_dir" "wireguard_hub" {
  source_dir      = "templates/ansible-roles/${local.wireguard_hub_role}"
  destination_dir = "local/ansible/roles/${local.wireguard_hub_role}"

  vars = {}
}

resource "template_dir" "wireguard_spoke" {
  source_dir      = "templates/ansible-roles/${local.wireguard_spoke_role}"
  destination_dir = "local/ansible/roles/${local.wireguard_spoke_role}"

  vars = {}
}

