## my public ip address - used in security groups

data "external" "my_public_ip" {
  program = ["scripts/my-public-ip.sh"]
}


## create the hub VPC

resource "aws_vpc" "hub" {
  cidr_block           = var.hub_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = var.hub_name
  }
}


## tag default VPC resources

resource "aws_default_route_table" "hub" {
  default_route_table_id = aws_vpc.hub.default_route_table_id
  tags = {
    Name = var.hub_name
  }
}

resource "aws_default_security_group" "hub" {
  vpc_id = aws_vpc.hub.id

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${data.external.my_public_ip.result["my_public_ip"]}/32"]
  }

  ingress {
    protocol    = "udp"
    from_port   = var.vpn_port
    to_port     = var.vpn_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.hub_name
  }
}

## create the internet gateway

resource "aws_internet_gateway" "hub" {
  vpc_id = aws_vpc.hub.id
  tags = {
    Name = var.hub_name
  }
}

## create subnets and routes

resource "aws_subnet" "hub" {
  vpc_id     = aws_vpc.hub.id
  cidr_block = aws_vpc.hub.cidr_block
  availability_zone = var.aws_zone

  tags = {
    Name = var.hub_name
  }
}

resource "aws_route_table_association" "hub" {
  route_table_id = aws_vpc.hub.main_route_table_id
  subnet_id      = aws_subnet.hub.id
}

resource "aws_route" "hub_default" {
  route_table_id         = aws_vpc.hub.main_route_table_id
  gateway_id             = aws_internet_gateway.hub.id
  destination_cidr_block = "0.0.0.0/0"
}

## ssh key and config

resource "tls_private_key" "hub_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "hub_ssh_private_key" {
  content         = tls_private_key.hub_ssh_key.private_key_pem
  filename        = local.hub_ssh_key_file
  file_permission = "0600"
}

resource "aws_key_pair" "hub_ssh_key" {
  key_name   = var.hub_name
  public_key = tls_private_key.hub_ssh_key.public_key_openssh
}

## the vpn server

resource "aws_instance" "hub" {
  instance_type = var.hub_instance_type
  ami           = var.hub_instance_ami

  disable_api_termination     = false
  associate_public_ip_address = true
  source_dest_check           = false

  subnet_id                   = aws_subnet.hub.id
  private_ip                  = cidrhost(aws_subnet.hub.cidr_block, 6)
  key_name                    = aws_key_pair.hub_ssh_key.key_name
  vpc_security_group_ids      = [aws_default_security_group.hub.id]

  user_data = templatefile("templates/ec2-setup-instance.sh.tpl", {
      server_name = var.hub_name
    })

  tags = {
    Name = var.hub_name
  }
}

