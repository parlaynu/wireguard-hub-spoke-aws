
resource "wireguard_asymmetric_key" "vpn_hub" {
}

resource "wireguard_asymmetric_key" "vpn_spokes" {
  for_each = var.spokes
}

