## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  

########################################################################################################################
#STEP ZERO: Set the variables
########################################################################################################################
#Note: $acmDirPath should become the directory into which we downloaded the AgileCloudManager (this will have top level subfolders modules, calls-to-modules, and pipelines)
$acmDirPath = '<Full-Path-Of-Directory-Into-Which-You-Cloned-AgileCloudManager\AgileCloudManager-Create-Update-Destroy>'
$driveLetter = "C:\"
#The following configRootDirPath is the root directory that will be created for all custom config, and which will be destroyed to remove the custom config after.  
$configRootDirName = "khn-config-aws"
$configRootDirPath = "C:\khn-config-aws\"
#The following configVarDirPath is where the .tfvars files will be put.
$configVarDirName = "VarsForTerraform"
$configVarDirPath = "C:\khn-config-aws\VarsForTerraform"
#The following configSSHKeyDirPath is where the .pem and .ppk files will be put.
#Note: the path C:\khn-config-aws\SSHKeysForTerraform is hard-coded into awskeymeta.tfvars .  So if you change configSSHKeyDirPath here you will need to change it there also.
$configSSHKeyDirName = "SSHKeysForTerraform"
$configSSHKeyDirPath = "C:\khn-config-aws\SSHKeysForTerraform"

#######################################################################################################################
#STEP ONE: Move directory that will contain config, so that we sandbox any sensitive values that will be put into it
#######################################################################################################################
$dirToMove = "Move-To-Secure-Directory-Outside-App-Path"
Write-Host "dirToMove is: $dirToMove"
$currentDir = (Get-Item -Path ".\").FullName
Write-Host "currentDir is: $currentDir" 
$sourceDir = $currentDir + "\" + $dirToMove
Write-Host "sourceDir is: $sourceDir"
New-Item -Path $driveLetter -Name $configRootDirName -ItemType "directory"
New-Item -Path $configRootDirPath -Name $configVarDirName -ItemType "directory"
Get-ChildItem -Path $sourceDir -Recurse |  Copy-Item -Destination $configVarDirPath
New-Item -Path $configRootDirPath -Name $configSSHKeyDirName -ItemType "directory"

#######################################################################################################################
#STEP TWO: Set the environment variables
#######################################################################################################################
# Set the two environment variables just for this session:
$RegKey ="Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment"
Set-ItemProperty -Path $RegKey -Name 'PATH_TO_ACM_VARS' -Value $configVarDirPath
Set-ItemProperty -Path $RegKey -Name 'PATH_TO_ACM_DIRECTORY' -Value $acmDirPath
# Set the environment variables to persist across every session until changed
[Environment]::SetEnvironmentVariable("PATH_TO_ACM_VARS", $configVarDirPath, "User")
[Environment]::SetEnvironmentVariable("PATH_TO_ACM_DIRECTORY", $acmDirPath, "User")
Write-Host "The permanent copies of the variables will not appear until after you restart PowerShell, so for now they should appear empty as follows: "
$env:PATH_TO_ACM_VARS
$env:PATH_TO_ACM_DIRECTORY
#Get the values of the new environment variables
Write-Host "The two session environment variables just created are: "
$new_acm_vars = (Get-ItemProperty $RegKey).PATH_TO_ACM_VARS
Write-Host "new_acm_vars is: $new_acm_vars"
$new_acm_dir = (Get-ItemProperty $RegKey).PATH_TO_ACM_DIRECTORY
Write-Host "new_acm_dir is: $new_acm_dir"
