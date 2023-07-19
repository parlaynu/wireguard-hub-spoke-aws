resource "local_file" "ssh_config" {
  content = templatefile("templates/ssh.cfg.tpl", {
    hub_name = var.hub_name,
    hub_public_ip = aws_instance.hub.public_ip
    hub_username  = var.hub_username,
    hub_ssh_key_file  = local.hub_ssh_key_file,
    spokes = var.spokes
    })
    
  filename        = "local/ssh.cfg"
  file_permission = "0640"
}

