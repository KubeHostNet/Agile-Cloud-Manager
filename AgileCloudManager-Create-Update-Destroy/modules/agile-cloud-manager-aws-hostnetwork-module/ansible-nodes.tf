## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  

  
####################################################  
# Below we create the USERDATA to get the instance ready to run ansible.
# The Terraform local simplifies Base64 encoding.  
locals {

  ansible-server-userdata = <<USERDATA
#!/bin/bash -xe
su - 
### Install software
sudo yum -y update
sudo amazon-linux-extras install -y epel
sudo yum -y install awscli
sudo yum install -y telnet
sudo yum -y install ansible
sudo yum install -y git
sudo yum install -y dos2unix
### Create user for Ansible
sudo groupadd -g 2002 ansible-host
sudo useradd -u 2002 -g 2002 -c "Ansible Automation Account" -s /bin/bash -m -d /home/ansible-host ansible-host
# Configure SSH for the user
sudo mkdir -p /home/ansible-host/.ssh
sudo cp -pr /home/ec2-user/.ssh/authorized_keys /home/ansible-host/.ssh/authorized_keys
sudo cp /home/ec2-user/.ssh/kubernetes-host.pem /home/ansible-host/.ssh/kubernetes-host.pem
chown -R ansible-host:ansible-host /home/ansible-host/.ssh
chmod 700 /home/ansible-host/.ssh
# Add user to sudoers with no password, ssh-only authentication
cat << 'EOF' > /etc/sudoers.d/ansible-host
User_Alias ANSIBLE_AUTOMATION = %ansible-host
ANSIBLE_AUTOMATION ALL=(ALL)      NOPASSWD: ALL
EOF
chmod 400 /etc/sudoers.d/ansible-host
cat << 'EOF' >> /etc/ssh/sshd_config
Match User ansible-host
        PasswordAuthentication no
        AuthenticationMethods publickey

EOF
# restart sshd
systemctl restart sshd
# Become new ansible-host user and move to its home directory
su - ansible-host
cd /home/ansible-host
echo "----- About to git clone the Ansible stuff (config, playbooks, scripts) "
sudo git clone https://github.com/greenriverit/ansible-kubernetes-kubeadm-playbooks.git && echo "git clone operation succeeded"
ls -al /home/ansible-host/
sudo chown -R ansible-host:ansible-host /home/ansible-host/ansible-kubernetes-kubeadm-playbooks
### Configure Ansible
sudo mv /home/ansible-host/ansible-kubernetes-kubeadm-playbooks/config/ansible.cfg /etc/ansible/
sudo dos2unix /etc/ansible/ansible.cfg
echo "----- About to sudo ls -al /etc/ansible"
sudo ls -al /etc/ansible
# Create directory structure inside new user's home directory
mkdir -p {playbooks,scripts,templates,logs}
mkdir /home/ansible-host/playbooks/group_vars/
sudo chown -R ansible-host:ansible-host /home/ansible-host/playbooks
sudo chown -R ansible-host:ansible-host /home/ansible-host/scripts
sudo chown -R ansible-host:ansible-host /home/ansible-host/templates
sudo chown -R ansible-host:ansible-host /home/ansible-host/logs
sudo mv /home/ansible-host/ansible-kubernetes-kubeadm-playbooks/playbooks/* /home/ansible-host/playbooks
# format the playbooks
sudo dos2unix /home/ansible-host/playbooks/organizer-CreateKubernetesClusterInsideHostNetwork.yml
sudo dos2unix /home/ansible-host/playbooks/create-GenericProvisionKubernetesNodes.yml
sudo dos2unix /home/ansible-host/playbooks/create-InitializeMasterKubernetesNode.yml
sudo dos2unix /home/ansible-host/playbooks/create-InitializeWorkerKubernetesNodes.yml
sudo dos2unix /home/ansible-host/playbooks/create-ProvisionRemoteKubernetesAdminMachine.yml
# Import and clean the associations between keys and inventory groups
sudo dos2unix /home/ansible-host/playbooks/group_vars/k8smaster.yml
sudo dos2unix /home/ansible-host/playbooks/group_vars/k8sworker.yml
sudo dos2unix /home/ansible-host/playbooks/group_vars/k8sadmin.yml
echo "----- About to sudo ls -al /home/ansible-host"
sudo ls -al /home/ansible-host
sudo ls -al /home/ansible-host/playbooks
#### Install Python
sudo yum -y install python-pip
sudo pip install boto3
sudo pip install ec2_metadata
####Configure the bash script to update the hosts
sudo mv /home/ansible-host/ansible-kubernetes-kubeadm-playbooks/scripts/write_hosts.sh /home/ansible-host/
sudo dos2unix /home/ansible-host/write_hosts.sh
sudo chown ansible-host:ansible-host /home/ansible-host/write_hosts.sh
sudo chmod 755 /home/ansible-host/write_hosts.sh
# make it a cron job (PUT write_hosts.sh IN A BETTER LOCATION SO THAT IT WILL NOT BE ACCIDENTALLY DESTROYED LATER BY AN UNKNOWING USER)
echo '* * * * * ansible-host bash /home/ansible-host/write_hosts.sh' | sudo tee  /etc/cron.d/refresh_hosts
# Make the .pem file only readable by the ansible-host user.  This will avoid a security roadblock and enable its use.
chmod 400 /home/ansible-host/.ssh/kubernetes-host.pem
# Should now be able to run PlayBooks.
USERDATA

}

data "aws_ami" "amazon-linux-2" {  
  most_recent = true
  
  owners = ["amazon"]
 
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  
  filter {
    name   = "architecture"
    values = ["x86_64*"]
  }

}  

resource "aws_instance" "ansible-server" {
  depends_on = [aws_internet_gateway.agile-cloud-manager-host]
  ami                         = data.aws_ami.amazon-linux-2.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ansible-node.id
  instance_type               = "t2.micro"
  key_name                    = var.name_of_ssh_key
  user_data_base64 = base64encode(local.ansible-server-userdata)
  source_dest_check           = false
  vpc_security_group_ids      = ["${aws_security_group.agile-cloud-manager-nodes.id}"]
  subnet_id                   = aws_subnet.agile-cloud-manager-host.id

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${var.path_to_ssh_keys}${var.name_of_ssh_key}.pem")
    host     = self.public_ip
  }

  # Copies the pem file
  provisioner "file" {
    source      = "${var.path_to_ssh_keys}kubernetes-host.pem"
    destination = "/home/ec2-user/.ssh/kubernetes-host.pem"
  }

  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
  
  tags = { Name = "Ansible-Server" }
}
