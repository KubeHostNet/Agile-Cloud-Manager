## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  


provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Not required: currently used in conjuction with using icanhazip.com to determine local workstation external IP
provider "http" {}

