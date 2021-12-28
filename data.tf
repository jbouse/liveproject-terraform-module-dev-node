data "aws_vpc" "default" {
  default = true
}

data "aws_ami" "rhel8" {
  most_recent = true
  name_regex  = "^RHEL-8"
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = ["RHEL-8.*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "template_file" "init" {
  template = file("${path.module}/user-data.yml")

  vars = {
    rh_org = var.rhsm_org
    rh_key = var.rhsm_key
  }
}

data "cloudinit_config" "this" {
  gzip = false

  part {
    content_type = "text/cloud-config"
    filename     = "init.cfg"
    content      = data.template_file.init.rendered
  }
}

resource "random_uuid" "node" {}
resource "random_uuid" "sg" {}
