# AWS EC2 Instance Terraform Outputs
# Public EC2 Instances - Bastion Host

## ec2_bastion_public_instance_ids
output "ec2_private_app1_instance_ids" {
  description = "list of the instance ID"
  value       = module.ec2_private_app1.id #change 5 - here ids are used for list
}

output "ec2_private_app2_instance_ids" {
  description = "list of the instance ID"
  value       = module.ec2_private_app2.id #change 5 - here ids are used for list
}

output "ec2_app1_private_ip" {
  description = "This is list of private IP for app1"
  value       = module.ec2_private_app1.private_ip
}

output "ec2_app2_private_ip" {
  description = "This is list of private IP for app1"
  value       = module.ec2_private_app2.private_ip
}


