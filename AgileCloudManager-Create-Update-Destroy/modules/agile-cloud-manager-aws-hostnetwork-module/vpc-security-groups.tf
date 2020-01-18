## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  


# Security groups and rules to allow the nodes to communicate with each other and with the outside world.  
# Here we are putting all nodes in the same security group and subnet.  
# This is a simple example.

resource "aws_security_group" "agile-cloud-manager-nodes" {
  name        = "agile-cloud-manager nodes"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.agile-cloud-manager-host.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "acm-nodes" }

}

resource "aws_security_group_rule" "agile-cloud-manager-nodes-ingress-each-other" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.agile-cloud-manager-nodes.id
  source_security_group_id = aws_security_group.agile-cloud-manager-nodes.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "agile-cloud-manager-cluster-admin-ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks       = ["${local.admin-external-cidr}"]
  security_group_id        = aws_security_group.agile-cloud-manager-nodes.id
}

resource "aws_security_group_rule" "host-nodes-ingress-each-other-ssh" {
  description              = "Allow Ansible server and Ansible clients to communicate with each other"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id        = aws_security_group.agile-cloud-manager-nodes.id
  source_security_group_id = aws_security_group.agile-cloud-manager-nodes.id
}

###############################################################################################################################################
### AUTOMATION WILL PUT "aws_security_group_rule" "vpc-peer-nodes-ingress-each-other" INTO SEPARATE FILE AT BUILD TIME FOR EASIER AUTOMATION.
###############################################################################################################################################