## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  


# VPC Building Blocks ( VPC, Subnets, Internet Gateway, Route Table )

resource "aws_vpc" "agile-cloud-manager-host" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "1"
  tags = { Name = "agile-cloud-manager-Host" }
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.agile-cloud-manager-host.id
  route_table_ids = ["${aws_route_table.agile-cloud-manager-host.id}"]
  service_name = "com.amazonaws.us-west-2.s3"
}

resource "aws_subnet" "agile-cloud-manager-host" {
  #count = 1
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block        = "10.0.0.0/24"
  vpc_id            = aws_vpc.agile-cloud-manager-host.id

}

resource "aws_internet_gateway" "agile-cloud-manager-host" {
  vpc_id = aws_vpc.agile-cloud-manager-host.id
}

##################################################################################################
### PLACING "aws_route_table" "agile-cloud-manager-host" IN SEPARATE FILE FOR CLEANER AUTOMATION
##################################################################################################

resource "aws_route_table_association" "agile-cloud-manager-host" {
  subnet_id      = aws_subnet.agile-cloud-manager-host.id
  route_table_id = aws_route_table.agile-cloud-manager-host.id
}
