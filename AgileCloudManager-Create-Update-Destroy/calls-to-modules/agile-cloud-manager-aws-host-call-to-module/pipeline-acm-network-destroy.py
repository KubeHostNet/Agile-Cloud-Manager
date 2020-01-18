## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  


import os  
import subprocess  
  
path_to_vars=os.environ['PATH_TO_ACM_VARS']  
path_to_vars=path_to_vars.replace('"', '')  
path_to_vars=path_to_vars.replace(' ', '')  
  
awsPubKey=path_to_vars+"\\awspublickey.tfvars"  
print("awsPubKey is: "+awsPubKey)  
awsVpcMeta=path_to_vars+"\\awsvpcmeta.tfvars"  
print("awsVpcMeta is: "+awsVpcMeta)  
awsKeyMeta=path_to_vars+"\\awskeymeta.tfvars"  
print("awsKeyMeta is: "+awsKeyMeta)  
  
commandToDestroy="terraform destroy -auto-approve -var-file="+awsPubKey+" -var-file="+awsVpcMeta+" -var-file="+awsKeyMeta  
print("commandToDestroy is: "+commandToDestroy)  
  
subprocess.run( commandToDestroy , shell=True, check=True)  
  