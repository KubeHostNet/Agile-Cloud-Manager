## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  


resource "aws_iam_role" "ansible-node" {
  name = "ansible-node-role"  
  
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "test_policy"
  role = aws_iam_role.ansible-node.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*",
        "ec2:ModifyInstanceAttribute"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "s3_policy"
  role = aws_iam_role.ansible-node.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ansible-node" {
  name = "ansible-node-profile"
  role = aws_iam_role.ansible-node.name
}
