# AWS EC2 Instance Terraform Module
# Bastion Host - EC2 Instance that will be created in VPC Public Subnet
module "bastion_ec2_instance" {

  depends_on = [
    module.vpc
  ]
  source = "terraform-aws-modules/ec2-instance/aws"
  #version = "2.17.0"

  name = "${var.environment}-Bastionhost"

  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  monitoring             = false
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id] #change 8 - Here we call security group id instead of this
  subnet_id              = module.vpc.public_subnets[0]                 #calling public subnets from vpc variables with index
  tags                   = local.common_tags
}

#This is the SG variable reference from the public subents output file
#vpc_security_group_ids = [module.public_bastion_sg.security_group_id]