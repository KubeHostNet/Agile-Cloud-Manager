## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  

  
####################################################  
# Below we create the USERDATA to get the instance ready to run terraform.
# We utilize a Terraform local here to simplify Base64 encoding this information.  
locals {

  terraform-host-userdata = <<USERDATA
#!/bin/bash -xe
su - 
### Install software
echo " ---- About to yum install software ---- "
sudo yum -y update
sudo amazon-linux-extras install -y epel
sudo yum -y install awscli
sudo yum install -y dos2unix
sudo yum install -y git

### Create user for Terraform
echo " ---- About to create user for Terraform ---- "
sudo groupadd -g 2002 terraform-host
sudo useradd -u 2002 -g 2002 -c "Terraform Automation Account" -s /bin/bash -m -d /home/terraform-host terraform-host

# Configure SSH for the user
echo " ---- About to configure ssh for the Terraform User ---- "
mkdir -p /home/terraform-host/.ssh
cp -pr /home/ec2-user/.ssh/authorized_keys /home/terraform-host/.ssh/authorized_keys

# Add user to sudoers with no password, ssh-only authentication
echo " ---- About to add the new user to sudoers with no password, ssh-only authentication ---- "
cat << 'EOF' > /etc/sudoers.d/terraform-host
User_Alias PIPELINE_SLAVE_AUTOMATION = %terraform-host
PIPELINE_SLAVE_AUTOMATION ALL=(ALL)      NOPASSWD: ALL
EOF
chmod 400 /etc/sudoers.d/terraform-host
cat << 'EOF' >> /etc/ssh/sshd_config
Match User terraform-host
        PasswordAuthentication no
        AuthenticationMethods publickey

EOF
# restart sshd
systemctl restart sshd

## Next install Terraform
echo " ---- About to install terraform. ---- "
sudo mkdir /home/terraform-host/terraform
cd /home/terraform-host/terraform
sudo wget -O /home/terraform-host/terraform/terraform_0.11.13_linux_amd64.zip https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
sudo unzip /home/terraform-host/terraform/terraform_0.11.13_linux_amd64.zip -d /home/terraform-host/terraform/
sudo chown -R terraform-host:terraform-host /home/terraform-host/*

echo " ---- About to change user. ---- "
sudo su - terraform-host
echo "export PATH=/home/terraform-host/terraform:$PATH" >> /home/terraform-host/.bash_profile
source ~/.bash_profile
# About to install python3
sudo yum install -y python3 python3-pip
echo " ---- about to whoami ---- "
whoami
echo " ---- About to echo $PATH ---- "
echo $PATH 

echo " ---- About to create a staging directory to receive the git repos ---- "
sudo mkdir /home/terraform-host/staging
cd /home/terraform-host/staging
sudo git clone https://github.com/greenriverit/Terraform-Kubernetes-AWS-Host-Network.git && echo "git clone operation succeeded for k8s aws hostnetwork. "
sudo git clone https://github.com/greenriverit/Terraform-VPC-Peering-For-Agile-Cloud-Manager.git && echo "git clone operation succeeded for vpc peering. "
sudo git clone https://github.com/greenriverit/Terraform-Kubernetes-Remote-Administrator-AWS.git && echo "git clone operation succeeded for k8sadmin. "
sudo git clone https://github.com/greenriverit/Pipeline-Functions-For-Kubernetes-Clusters.git && echo "git clone operation succeeded for Pipeline Functions. "
sudo chown -R terraform-host:terraform-host /home/terraform-host/*

echo " ---- About to create the projects directory and its subdirectories ---- "
sudo mkdir /home/terraform-host/projects
sudo mkdir /home/terraform-host/projects/terraform
sudo mkdir /home/terraform-host/projects/terraform/k8sadmin
sudo mkdir /home/terraform-host/projects/terraform/pipelines
sudo mkdir /home/terraform-host/tfvars

echo " ---- About to move the things that were cloned from GitHub.com/greenriverit ---- "
sudo mv /home/terraform-host/staging/Terraform-Kubernetes-AWS-Host-Network/move-to-secure-directory-outside-app-path/portable-k8s/ /home/terraform-host/tfvars/portable-k8s/
sudo mv /home/terraform-host/staging/Terraform-Kubernetes-AWS-Host-Network/kubeadm-aws-hostnetwork/ /home/terraform-host/projects/terraform/
sudo mv /home/terraform-host/staging/Terraform-VPC-Peering-For-Agile-Cloud-Manager/move-to-secure-directory-outside-app-path/acm /home/terraform-host/tfvars/
sudo mv /home/terraform-host/staging/Terraform-VPC-Peering-For-Agile-Cloud-Manager/move-to-secure-directory-outside-app-path/acm-peer-config/ /home/terraform-host/tfvars/
sudo mv /home/terraform-host/staging/Terraform-VPC-Peering-For-Agile-Cloud-Manager/move-to-secure-directory-outside-app-path/k8s-peer-config/ /home/terraform-host/tfvars/
sudo mv /home/terraform-host/staging/Terraform-VPC-Peering-For-Agile-Cloud-Manager/vpc-peering-config/ /home/terraform-host/projects/terraform/
sudo mv /home/terraform-host/staging/Terraform-VPC-Peering-For-Agile-Cloud-Manager/vpc-peering-connection/ /home/terraform-host/projects/terraform/
sudo mv /home/terraform-host/staging/Terraform-Kubernetes-Remote-Administrator-AWS/move-to-secure-directory-outside-app-path/k8sadmin/ /home/terraform-host/tfvars/ 
sudo mv /home/terraform-host/staging/Terraform-Kubernetes-Remote-Administrator-AWS/call-to-module/ /home/terraform-host/projects/terraform/k8sadmin/
sudo mv /home/terraform-host/staging/Terraform-Kubernetes-Remote-Administrator-AWS/module/ /home/terraform-host/projects/terraform/k8sadmin/
sudo mv -v /home/terraform-host/staging/Pipeline-Functions-For-Kubernetes-Clusters/Cluster-CRUD-Functions/* /home/terraform-host/projects/terraform/pipelines

sudo chown -R terraform-host:terraform-host /home/terraform-host/*

echo " ---- About to set environment variables "
sudo mv /home/ec2-user/setEnvironmentVariables.sh /etc/profile.d/setEnvironmentVariables.sh
sudo chown -R root:root /etc/profile.d/setEnvironmentVariables.sh
sudo chmod +x /etc/profile.d/setEnvironmentVariables.sh
sudo dos2unix /etc/profile.d/setEnvironmentVariables.sh
sudo /etc/profile.d/setEnvironmentVariables.sh

#### Extract zip files to destination folders

cd /home/terraform-host/
sudo chown -R terraform-host:terraform-host /home/terraform-host/*
# About to install requests using pip3.
pip3 install requests
sudo pip3 install boto3
#######################################################################################################################
## Prep the key to be pushed to k8sadmin.  Replace this later with secure, enterprise-grade, key management solution.  
## The following is just a bandaid to enable other aspects of this POC to be free-standing. 
#######################################################################################################################
sudo mv /home/ec2-user/kubernetes-host.pem /home/terraform-host/.ssh/kubernetes-host.pem  
sudo chown -R terraform-host:terraform-host /home/terraform-host/.ssh  
sudo chmod 700 /home/terraform-host/.ssh  
sudo mkdir /home/terraform-host/stage-keys
sudo cp /home/terraform-host/.ssh/kubernetes-host.pem /home/terraform-host/stage-keys/
sudo chown terraform-host:terraform-host /home/terraform-host/stage-keys/kubernetes-host.pem
sudo chmod -R 777 /home/terraform-host/stage-keys
sudo chown -R terraform-host:terraform-host /home/terraform-host/stage-keys
sudo chmod 400 /home/terraform-host/.ssh/kubernetes-host.pem  
USERDATA

}

resource "aws_instance" "terraform-host" {
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.terraform-host.id
  instance_type               = "m4.large"
  key_name                    = "ansible-server"
  user_data_base64 = base64encode(local.terraform-host-userdata)
  source_dest_check           = false
  vpc_security_group_ids      = ["${aws_security_group.agile-cloud-manager-nodes.id}"]
  subnet_id                   = aws_subnet.agile-cloud-manager-host.id

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${var.path_to_ssh_keys}ansible-server.pem")
    host     = self.public_ip
  }

  # Copies the setEnvironmentVariables.sh file
  provisioner "file" {
    source      = "${path.module}/setEnvironmentVariables.sh"
    destination = "/home/ec2-user/setEnvironmentVariables.sh"
  }

  # Copies the kubernetes-host.pem file
  provisioner "file" {
    source      = "${var.path_to_ssh_keys}kubernetes-host.pem"
    destination = "/home/ec2-user/kubernetes-host.pem"
  }

  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
  
  tags = {
    Name = "terraform-host"
  }
}
