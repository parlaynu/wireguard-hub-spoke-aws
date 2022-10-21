[hub]
${hub_name}

[spokes]
%{ for name in spoke_names ~}
${name}
%{ endfor ~}
