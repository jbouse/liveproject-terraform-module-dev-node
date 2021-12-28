output "public_dns" {
  value = module.ec2-instance.public_dns
}

output "instance_id" {
  value = module.ec2-instance.spot_instance_id
}