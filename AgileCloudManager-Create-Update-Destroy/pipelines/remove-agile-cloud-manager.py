## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  

import networkdeploymentfunctions as ndf
import os 

path_to_acm_dir=os.environ['PATH_TO_ACM_DIRECTORY']
path_to_acm_dir=path_to_acm_dir.replace('"', '')
path_to_acm_dir=path_to_acm_dir.replace(' ', '')
print("path_to_acm_dir is: "+path_to_acm_dir)
path_to_call_to_acm_module = path_to_acm_dir+"\\calls-to-modules\\agile-cloud-manager-aws-host-call-to-module"
print("path_to_call_to_acm_module is: "+path_to_call_to_acm_module)

###############################################################################
### Remove the Agile Cloud Manager Host Network
###############################################################################
ndf.removeAgileCloudManagerHostNetwork( 'python pipeline-acm-network-destroy.py', path_to_call_to_acm_module)
print("                                  ")
print("  **** Finished Removing Agile Cloud Manager Host Network. ****")
print("                                  ")
