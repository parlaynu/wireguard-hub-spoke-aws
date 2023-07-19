##
## hub definition
##

variable "aws_profile" {
  default = ""
}

variable "aws_region" {
  default = "ap-southeast-2"
}

variable "aws_zone" {
  default = "ap-southeast-2c"
}

variable "hub_name" {
  default = "wg-hub"
}

variable "hub_cidr_block" {
  default = "192.168.100.0/24"
}

variable "hub_username" {
  default = "ubuntu"
}

variable "hub_instance_type" {
  default = "t3.nano"
}

variable "hub_instance_ami" {
  default = "ami-09a5c873bc79530d9"
}

variable "hub_instance_ifname" {
  default = "ens5"
}

variable "hub_stubby_upstream_servers" {
  type = list(object({
    ip_address = string
    tls_auth_name = string
  }))
  default = [
    {
      ip_address = "1.1.1.1"
      tls_auth_name =  "cloudflare-dns.com"
    },
    {
      ip_address = "1.0.0.1"
      tls_auth_name =  "cloudflare-dns.com"
    }
  ]
}

locals {
  hub_ssh_key_file = "local/pki/${var.hub_name}"
}

##
## spoke definitions
##

variable "spokes" {
  type = map(object({
    access_ip = string
    ifname = string
    username = string
    ssh_key_file = string
    keepalive_interval = number
    local_networks = list(string)
    }))
  default = {
    spoke1 = {
      access_ip = "192.168.0.23"
      ifname = "eth0"
      username = "ubuntu"
      ssh_key_file = "~/.ssh/spoke1"
      keepalive_interval = 0    # 0 - disables persistent keepalive
      local_networks = ["192.168.0.0/24"]
    },
    spoke2 = {
      access_ip = "192.168.10.11"
      ifname = "eth0"
      username = "ubuntu"
      ssh_key_file = "~/.ssh/spoke2"
      keepalive_interval = 25   # 25 - reasonable value according to wireguard documentation
      local_networks = ["192.168.10.0/24"]
    }
  }
}


##
## vpn definitions
##

variable "vpn_cidr_block" {
  default = "192.168.101.0/24"
}

variable "vpn_port" {
  default = 51820
}

locals {
  vpn_hub_ip = cidrhost(var.vpn_cidr_block, 1)
  
  vpn_spoke_keys = keys(var.spokes)
  vpn_spoke_ips = {for idx in range(length(var.spokes)) : local.vpn_spoke_keys[idx] => cidrhost(var.vpn_cidr_block, idx+5)}  
}

