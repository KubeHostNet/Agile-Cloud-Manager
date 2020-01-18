## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  

provider "aws" {
  region     = "${var.region}"
}

variable "region" { default = "us-west-2" }

# Creating group khn-testing
resource "aws_iam_group" "khn-testing" { name = "khn-testing" }

# create users
resource "aws_iam_user" "khn-testing-k8speerconfig" { name = "khn-testing-k8speerconfig" }
resource "aws_iam_user" "khn-testing-acmpeerconfig" { name = "khn-testing-acmpeerconfig" }
resource "aws_iam_user" "khn-testing-k8sadmin" { name = "khn-testing-k8sadmin" }
resource "aws_iam_user" "khn-testing-k8shost" { name = "khn-testing-k8shost" }

# add users to a group :)
resource "aws_iam_group_membership" "khn-testing-users" {
    name = "khn-testing-users"
    users = [
        "${aws_iam_user.khn-testing-k8speerconfig.name}",
        "${aws_iam_user.khn-testing-acmpeerconfig.name}",
        "${aws_iam_user.khn-testing-k8sadmin.name}",
        "${aws_iam_user.khn-testing-k8shost.name}",
    ]
    group = "${aws_iam_group.khn-testing.name}"
}

# Create IAM policy
resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"
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
                "s3:*",
                "autoscaling:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# Attach policy to group
resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = "${aws_iam_group.khn-testing.name}"
  policy_arn = "${aws_iam_policy.policy.arn}"
}

# Create access keys for each user
#SECURITY HOLE: THESE ACCESS KEYS WILL NEED TO BE ENCRYPTED SO THAT THEY DO NOT CONTINUE TO BE WRITTEN TO THE CONSOLE IN UN-ENCRYPTED FORM
resource "aws_iam_access_key" "khn-testing-k8speerconfig" { user = "${aws_iam_user.khn-testing-k8speerconfig.name}" }
resource "aws_iam_access_key" "khn-testing-acmpeerconfig" { user = "${aws_iam_user.khn-testing-acmpeerconfig.name}" }
resource "aws_iam_access_key" "khn-testing-k8sadmin" { user = "${aws_iam_user.khn-testing-k8sadmin.name}" }
resource "aws_iam_access_key" "khn-testing-k8shost" { user = "${aws_iam_user.khn-testing-k8shost.name}" }

#Export the access keys so they can be used in the automation
output "secret_id_khn-testing-k8speerconfig" { value = "${aws_iam_access_key.khn-testing-k8speerconfig.id}" }
output "secret_id_khn-testing-acmpeerconfig" { value = "${aws_iam_access_key.khn-testing-acmpeerconfig.id}" }
output "secret_id_khn-testing-k8sadmin" { value = "${aws_iam_access_key.khn-testing-k8sadmin.id}" }
output "secret_id_khn-testing-k8shost" { value = "${aws_iam_access_key.khn-testing-k8shost.id}" }

