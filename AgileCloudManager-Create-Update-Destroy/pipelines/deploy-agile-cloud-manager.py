## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  


import os 
import networkdeploymentfunctions as ndep
import networkvalidation as nval

#################################################################################
#### Variable definition for function calls
#################################################################################

path_to_acm_dir=os.environ['PATH_TO_ACM_DIRECTORY']
path_to_acm_dir=path_to_acm_dir.replace('"', '')
path_to_acm_dir=path_to_acm_dir.replace(' ', '')
print("path_to_acm_dir is: "+path_to_acm_dir)
path_to_call_to_acm_module = path_to_acm_dir+"\\calls-to-modules\\agile-cloud-manager-aws-host-call-to-module"
print("path_to_call_to_acm_module is: "+path_to_call_to_acm_module)

command_to_call_acm_module = 'python pipeline-acm-network-apply.py'

################################################################################  
### 1. NOW DEPLOY THE AGILE CLOUD MANAGER HOST NETWORK
################################################################################  
ndep.deployAgileCloudManagerHostNetwork( command_to_call_acm_module, path_to_call_to_acm_module)
nval.validateAgileCloudManagerHostNetwork(ndep.cidr_subnet_acm, ndep.cidr_subnet_list_acm, ndep.security_group_id_acm_nodes, ndep.vpc_id_acm, ndep.route_table_id_acm_host)
print("                                  ")
print("  **** Finished Deploying Agile Cloud Manager Host Network. ****")
print("                                  ")

print(" internet_gateway_acm_host is: " +ndep.internet_gateway_acm_host)
print(" security_group_id_acm_nodes is: " +ndep.security_group_id_acm_nodes)
print(" cidr_subnet_acm_id is: " +ndep.cidr_subnet_acm_id)
