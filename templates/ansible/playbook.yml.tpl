---
- hosts: hub
  become: yes
  gather_facts: yes
  
  vars:
    ansible_python_interpreter: "/usr/bin/env python3"

  tasks:
  - import_role:
      name: ${gateway_role}

  - import_role:
      name: ${iptables_role}
    
  - import_role:
      name: ${stubby_role}

  - import_role:
      name: ${wireguard_hub_role}

- hosts: spokes
  become: yes
  gather_facts: yes
  
  vars:
    ansible_python_interpreter: "/usr/bin/env python3"

  tasks:
  - import_role:
      name: ${gateway_role}
    
  - import_role:
      name: ${iptables_role}

  - import_role:
      name: ${wireguard_spoke_role}

