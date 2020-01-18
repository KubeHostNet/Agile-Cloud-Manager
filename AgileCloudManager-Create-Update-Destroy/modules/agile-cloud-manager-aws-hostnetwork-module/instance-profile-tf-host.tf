## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  


resource "aws_iam_role" "terraform-host" {
  name = "terraform-host-role"  
  
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

## TIGHTEN AND RENAME THE FOLLOWING TO RESTRICT TO ONLY THE ACTIONS NEEDED.  IT IS TOO POWERFUL NOW.
resource "aws_iam_role_policy" "terraform_automation_policy" {
  name = "description_policy"
  role = aws_iam_role.terraform-host.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "elasticfilesystem:*",
                "ec2:*", 
                "iam:*",
                "autoscaling:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "s3_policy_terraform" {
  name = "s3_policy"
  role = aws_iam_role.terraform-host.id

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

resource "aws_iam_instance_profile" "terraform-host" {
  name = "terraform-host-profile"
  role = aws_iam_role.terraform-host.name
}
