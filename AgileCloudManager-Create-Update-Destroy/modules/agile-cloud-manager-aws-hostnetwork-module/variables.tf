## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  


# Using these data sources allows the configuration to be generic for any region.
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

variable "access_key" { }
variable "region" { }
variable "path_to_ssh_keys" { }
variable "name_of_ssh_key" { }
variable "name_of_ssh_key_k8sadmin" { }

# Workstation External IP. Override with variable or hardcoded value if necessary.
data "http" "admin-external-ip" { url = "http://ipv4.icanhazip.com" }
locals { admin-external-cidr = "${chomp(data.http.admin-external-ip.body)}/32" }

#############Output variables
output "security_group_id_acm_nodes" { value = "${aws_security_group.agile-cloud-manager-nodes.id}" }
output "vpc_id_acm" { value = "${aws_vpc.agile-cloud-manager-host.id}" }
output "cidr_subnet_acm" { value = "${aws_subnet.agile-cloud-manager-host.cidr_block}" }
output "cidr_subnet_acm_id" { value = "${aws_subnet.agile-cloud-manager-host.id}" }
output "route_table_id_acm_host" { value = "${aws_route_table.agile-cloud-manager-host.id}" }
output "internet_gateway_acm_host" { value = "${aws_internet_gateway.agile-cloud-manager-host.id}" }
