# Agile Cloud Manager   
  
This is automation code for creating, updating, and deleting instances of the Agile Cloud Manager, which is a tool for developing and operating software-defined host networks for Kubernetes clusters as a part of the KubeHostNet open source project.  
  
Clone and run this repository AFTER you have successfully used the `DevBox-Provisioner-Windows` repository to provision a Windows DevBox into which you can now clone this repository.  
  
You will need administrator privileges on your Windows DevBox in order to run the code in this repository.  Specifically, PowerShell will need to be run as an administrator in order to perform operations such as writing to the root directory of your herd drive.  
  
# Instructions  
  
## Prerequisites  
  
You will need the following in order to successfully clone and use this repository:  
  
1. A Windows DevBox which has already been provisioned using the instructions and code from the DevBox-Provisioner-Windows repository
2. An AWS account to which you can login and view the console
3. Two .pem files
4. One AWS public key
5. Putty installed on your Windows DevBox (Add this to DevBox-Provisioner-Windows)

## Installation Instructions  
  
You can get this working in a few minutes by following these instructions:  
   
1.	Clone this AgileCloudManager repository  
--* Note the full path of and including the AgileCloudManager-Create-Update-Destroy folder.  
--* For example, C:\path\to\AgileCloudManager\AgileCloudManager-Create-Update-Destroy  
  
2.	Code Editor  
--* In your textual code editor of choice, open up the createConfigForAgileCloudManagerControl.ps1 PowerShell script that is located in the C:\path\to\AgileCloudManager\Initial-Setup directory, and set the $acmDirPath variable to read ‘C:\path\to\AgileCloudManager\AgileCloudManager-Create-Update-Destroy’ instead of '<Full-Path-Of-Directory-Into-Which-You-Cloned-AgileCloudManager\AgileCloudManager-Create-Update-Destroy>'
  
3.  PowerShell
--* Open PowerShell as an administrator
--* Navigate the PowerShell command prompt to the Initial-Setup subdirectory within the directory into which you cloned AgileCloudManager
--* For example, C:\path\to\AgileCloudManager\Initial-Setup
  
4.  Automated Step on DevBox:
--* Type .\createConfigForAgileCloudManagerControl.ps1
--* Creates the directory C:\khn-config-aws\VarsForTerraform
--* Copies the .tfvars files to C:\khn-config-aws\VarsForTerraform
--* Sets environment variables for:
--* PATH_TO_ACM_VARS = "C:\khn-config-aws\VarsForTerraform"
--* PATH_TO_ACM_DIRECTORY = '<Full-Path-Of-Directory-Into-Which-You-Cloned-AgileCloudManager\AgileCloudManager-Create-Update-Destroy>'  
  
5.  Creates the directory into which the .pem files will be placed
--* C:\khn-config-aws\SSHKeysForTerraform
--* Note the path of this directory has already been coded into “awskeymeta.tfvars” as the value for the “path_to_ssh_keys” variable.
--* So if you want to change this directory path in this script, you will also have to change it in “awskeymeta.tfvars”
  
6.  Code Editor (Possibly AWS Management Console also)
--* Copy an AWS Public Key into C:\khn-config-aws\VarsForTerraform\awspublickey.tfvars
--* If you are doing this at work, add IAM permissions to the key to match the IAM Role Policies you can read in the Terraform code. 
--* If you are doing this at home with your personal AWS account, then you can use your root public key to start, until you learn about IAM.
  
7.  Windows Explorer
--* Add two .pem files into the directory indicated by the “path_to_ssh_keys” variable in awskeymeta.tfvars.  
--* path_to_ssh_keys = "C:\\khn-config-aws\\SSHKeysForTerraform\\"
--* Directory name: C:\khn-config-aws\VarsForTerraform\awskeymeta.tfvars
--* Key names:  “ansible-server” and “kubernetes-host”
--* The names of these keys must correspond with the file names shown in the Terraform code (awskeymeta.tfvars) and in your AWS Account.  
  
8.  AWS Web Management Console:
--* Log in to the AWS Console and navigate to the dashboards that report the instances that are currently deployed in the region into which you will be deploying AgileCloudManager.  For us-west-2 the dashboards for EC2 and VPC instances are:    
--* EC2:  https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2#Home:  
--* VPC:  https://us-west-2.console.aws.amazon.com/vpc/home?region=us-west-2#dashboard:  
  
9.  PowerShell  
--* Open a NEW instance of Windows CMD Command Prompt as Administrator.  
--* This new instance is necessary so that the environment variables can contain the values created in preceding steps above.
--* In your new local PowerShell instance, navigate to the pipelines/ directory
--* Type python deploy-agile-cloud-manager.py in the command line in the pipelines/ directory of the cloned repository.  
  
10.  AWS Web Management Console:  
--* Watch the instances become auto-created in the AWS UI console
--* From the AWS Web Management Console, enter the public IP addresses for the EC2 instances that were created, which are summarized in the following information:  
--* EC2 Instance Name	Username for login	IP	Key Name
--* terraform-host	terraform-host	<ip-address-goes-here>	ansible-server
--* Ansible-Server	ansible-host	<ip-address-goes-here>	ansible-server
--* k8sadmin		Will be created downstream	kubernetes-host
  
11.	Putty  
--* Open Putty on the Windows DevBox  
--* Putty into the `Ansible-Server` EC2 instance using the `ansible-server` ppk file and the `ansible-host` username.  Then type `ls -al playbooks` and see that there are several playbooks available for your use  
--* Putty into the `terraform-host` EC2 instance using the `ansible-server` ppk file and the `terraform-host` username.  Then type `ls -al projects/terraform/pipelines` and see that scripts exist that will create and destroy host networks for Kubernetes Clusters.  
--* At the start of both of the preceding Putty sessions, click to accept the unknown key.  The warning message for unknown key is normal the first time you use a new key.  
   
**You have now created an instance of the Agile Cloud Manager.  Other sections will explain how you can use it.**  
  
## Removal Instructions  
  
1.  PowerShell  
--* Back in the PowerShell instance you are running as administrator in your Windows DevBox  
--* Make sure that you are in the right directory by typing: `cd C:\path\to\AgileCloudManager\AgileCloudManager-Create-Update-Destroy\pipelines`   
--* Run the undeploy command as: `.\remove-agile-cloud-manager.py`  
--* Watch the console print out  
  
2.  AWS Web Management console  
--* In the AWS Web Management console links given above,  
--* watch the EC2 and VPC-related infrastructure being terminated.  
--* Wait to confirm that all have been terminated.  
  
The primary development of KubeHostNet and all its components was done by [Green River IT, Incorporated](http://greenriverit.com) in California.  It is released under the generous license terms defined in the [LICENSE](LICENSE.txt) file.  
  
## Support  
  
If you encounter any problems with this release, please create a 
[GitHub Issue](https://github.com/kubehostnet/Agile-Cloud-Manager/issues).  
  
For commercial support please send us an email.  
  
## Dependencies  
  
You will need a Windows computer with Administrator privileges.  
  
The code in this repository will automatically install other dependencies.  
  
The code in this repository is intended to be used with code in other repositories at https://github.com/kubehostnet  
  