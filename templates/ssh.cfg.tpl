# the hub
Host ${hub_name}
  Hostname ${hub_public_ip}
  User ${hub_username}
  IdentityFile ${hub_ssh_key_file}
  IdentitiesOnly yes


# the spokes
%{ for key, value in spokes ~}
Host ${key}
  Hostname ${value.access_ip}
  User ${value.username}
  IdentityFile ${value.ssh_key_file}
  IdentitiesOnly yes
%{ endfor ~}

