# Create a Null Resource and Provisioners
resource "null_resource" "name" {
  depends_on = [module.bastion_ec2_instance]
  connection {
    type        = "ssh"
    host        = aws_eip.bastion_elastip_ip.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("private-key/newdocker.pem")
  }




  # Copies the terraform-key.pem file to /tmp/terraform-key.pem
  provisioner "file" {
    source      = "private-key/newdocker.pem"
    destination = "/tmp/newdocker.pem"
  }

  # Using remote-exec provisioner fix the private key permissions on Bastion Host
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/newdocker.pem"
    ]
  }
  # local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)
  provisioner "local-exec" {
    command     = "echo VPC created on `date` and VPC ID: ${module.vpc.vpc_id} >> creation-time-vpc-id.txt"
    working_dir = "local-exec-output-files/"
    #on_failure = continue
  }
}

/*
## Local Exec Provisioner:  local-exec provisioner (Destroy-Time Provisioner - Triggered during deletion of Resource)
  provisioner "local-exec" {
    command = "echo Destroy time prov `date` >> destroy-time-prov.txt"
    working_dir = "local-exec-output-files/"
    when = destroy
    #on_failure = continue
  }    
}
*/