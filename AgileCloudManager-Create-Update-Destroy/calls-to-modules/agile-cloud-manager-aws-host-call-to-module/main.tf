## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  


module "agile-cloud-manager-aws-hostnetwork" {
  source = "..\\..\\modules\\agile-cloud-manager-aws-hostnetwork-module"

  region = "${var.acm_region}"
  access_key = "${var.acm_public_access_key}"
  secret_key = "${var.acm_secret_access_key}"
  path_to_ssh_keys = "${var.path_to_ssh_keys}"
  name_of_ssh_key = "${var.name_of_ssh_key}"
  name_of_ssh_key_k8sadmin = "${var.name_of_ssh_key_k8sadmin}"

}

variable "acm_region" { }
variable "acm_public_access_key" { }
variable "acm_secret_access_key" { }
variable "path_to_ssh_keys" { }
variable "name_of_ssh_key" { }
variable "name_of_ssh_key_k8sadmin" { }

##Output variables
output "security_group_id_acm_nodes" { value = "${module.agile-cloud-manager-aws-hostnetwork.security_group_id_acm_nodes}" }
output "vpc_id_acm" { value = "${module.agile-cloud-manager-aws-hostnetwork.vpc_id_acm}" }
output "cidr_subnet_acm" { value = "${module.agile-cloud-manager-aws-hostnetwork.cidr_subnet_acm}" }
output "cidr_subnet_acm_id" { value = "${module.agile-cloud-manager-aws-hostnetwork.cidr_subnet_acm_id}" }
output "route_table_id_acm_host" { value = "${module.agile-cloud-manager-aws-hostnetwork.route_table_id_acm_host}" }
output "internet_gateway_acm_host" { value = "${module.agile-cloud-manager-aws-hostnetwork.internet_gateway_acm_host}" }

