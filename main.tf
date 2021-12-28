module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.7.0"

  name            = "development-node"
  use_name_prefix = true
  description     = "Access for development-node"
  vpc_id          = data.aws_vpc.default.id

  ingress_cidr_blocks = var.admin_cidr
  ingress_rules       = ["ssh-tcp", "all-icmp"]
  egress_rules        = ["all-all"]

  tags = {
    Cluster     = "None"
    Project     = "Manning"
    Environment = "Dev"
    Creator     = "Terraform"
    Expires     = "Never"
    Service     = "SSH,ICMP"
    Management  = "jbouse+lp@undergrid.net"
    UUID        = random_uuid.sg.result
    Freetext    = ""
  }
}

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.3.0"

  name = "development-node"

  ami                         = data.aws_ami.rhel8.id
  instance_type               = "t3.micro"
  key_name                    = "development-node-keypair"
  vpc_security_group_ids      = [module.security-group.security_group_id]
  associate_public_ip_address = true
  user_data_base64            = data.cloudinit_config.this.rendered

  metadata_options = {
    http_tokens = "required"
  }

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      iops        = 3000
      throughput  = 125
    }
  ]

  tags = {
    Cluster     = "None"
    Project     = "Manning"
    Environment = "Dev"
    Creator     = "Terraform"
    Expires     = "Never"
    Service     = "None"
    Management  = "jbouse+lp@undergrid.net"
    UUID        = random_uuid.node.result
    Freetext    = ""
  }
}