#!/bin/bash

## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  


export TF_VAR_PATH_TO_K8S_MODULE=/home/terraform-host/projects/terraform/kubeadm-aws-hostnetwork/module/
export TF_VAR_PATH_TO_CALL_TO_K8S_MODULE=/home/terraform-host/projects/terraform/kubeadm-aws-hostnetwork/call-to-module/
export TF_VAR_COMMAND_TO_CALL_K8S_MODULE="python3 pipeline-kubeadm-network-apply.py"
export TF_VAR_PATH_TO_PEERING_MODULE=/home/terraform-host/projects/terraform/vpc-peering-connection/module/
export TF_VAR_PATH_TO_CALL_TO_PEERING_MODULE=/home/terraform-host/projects/terraform/vpc-peering-connection/call-to-module/
export TF_VAR_PATH_TO_CALL_TO_PEERING_MODULE_SHORT=/home/terraform-host/projects/terraform/vpc-peering-connection/call-to-module/
export TF_VAR_COMMAND_TO_CALL_PEERING_MODULE="python3 pipeline-vpc-peering-apply.py"
export TF_VAR_PATH_TO_K8S_IAM_KEYS=/home/terraform-host/tfvars/portable-k8s/
export TF_VAR_PATH_TO_K8SADMIN_IAM_KEYS=/home/terraform-host/tfvars/k8sadmin/
export TF_VAR_PATH_TO_ACM_IAM_KEYS=/home/terraform-host/tfvars/acm/
export TF_VAR_PATH_TO_K8SPEERCONFIG_IAM_KEYS=/home/terraform-host/tfvars/k8s-peer-config/
export TF_VAR_PATH_TO_ACMPEERCONFIG_IAM_KEYS=/home/terraform-host/tfvars/acm-peer-config/

export TF_VAR_COMMAND_TO_APPLY_ACM_PEER_CONFIG="python3 pipeline-acceptor-peering-config-apply.py"
export TF_VAR_COMMAND_TO_DESTROY_ACM_PEER_CONFIG="python3 pipeline-acceptor-peering-config-destroy.py"

export TF_VAR_COMMAND_TO_APPLY_K8S_PEER_CONFIG="python3 pipeline-k8s-peer-config-apply.py"
export TF_VAR_COMMAND_TO_DESTROY_K8S_PEER_CONFIG="python3 pipeline-k8s-peer-config-destroy.py"

export TF_VAR_PATH_TO_CALL_K8SPEERCONFIG_MODULE=/home/terraform-host/projects/terraform/vpc-peering-config/requestor-k8s/call-to-module-vpc-peering-config/
export TF_VAR_PATH_TO_CALL_ACMPEERCONFIG_MODULE=/home/terraform-host/projects/terraform/vpc-peering-config/acceptor-acm/call-to-module-vpc-peering-config/
