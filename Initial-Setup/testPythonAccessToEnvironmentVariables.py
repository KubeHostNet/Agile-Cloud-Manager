## Copyright 2019 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  
  
import os 
  
#################################################################################
#### Variable definition for function calls
#################################################################################

path_to_acm_dir=os.environ['PATH_TO_ACM_DIRECTORY']
path_to_acm_dir=path_to_acm_dir.replace('"', '')
path_to_acm_dir=path_to_acm_dir.replace(' ', '')
print("path_to_acm_dir is: "+path_to_acm_dir)
path_to_call_to_acm_module = path_to_acm_dir+"\\calls-to-modules\\agile-cloud-manager-aws-host-call-to-module"
print("path_to_call_to_acm_module is: "+path_to_call_to_acm_module)
