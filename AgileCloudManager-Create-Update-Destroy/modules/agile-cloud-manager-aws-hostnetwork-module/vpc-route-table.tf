## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  


resource "aws_route_table" "agile-cloud-manager-host" {
  vpc_id = aws_vpc.agile-cloud-manager-host.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.agile-cloud-manager-host.id
  }

  tags = { Name = "acm-host" }

}