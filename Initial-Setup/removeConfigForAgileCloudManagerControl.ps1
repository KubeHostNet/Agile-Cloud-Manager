## Copyright 2020 Green River IT as described in LICENSE.txt distributed with this project on GitHub.  
## Start at https://github.com/KubeHostNet/  

$configRootDirPath = "C:\khn-config-aws\"

#STEP ONE: Remove the configuration files and their containing directories
Remove-Item -Recurse -Force $configRootDirPath

#STEP TWO: Remove system-level environment variables
Write-Host "Now delete: "
[System.Environment]::SetEnvironmentVariable('PATH_TO_ACM_VARS', $null,[System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('PATH_TO_ACM_DIRECTORY', $null,[System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('PATH_TO_ACM_VARS', $null,[System.EnvironmentVariableTarget]::User)
[System.Environment]::SetEnvironmentVariable('PATH_TO_ACM_DIRECTORY', $null,[System.EnvironmentVariableTarget]::User)
Write-Host "The two variables just deleted are: "
$old_acm_vars = (Get-ItemProperty 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment').PATH_TO_ACM_VARS
Write-Host "old_acm_vars is: $old_acm_vars"
$old_acm_dir = (Get-ItemProperty 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment').PATH_TO_ACM_DIRECTORY
Write-Host "old_acm_dir is: $old_acm_dir"
#Delete the environment variables Permanently
[Environment]::SetEnvironmentVariable("PATH_TO_ACM_VARS", $null, "User")
[Environment]::SetEnvironmentVariable("PATH_TO_ACM_DIRECTORY", $null, "User")
Write-Host "The permanent versions of the environment variables will not disappear until you restart PowerShell, so for now they should remain as:"
$env:PATH_TO_ACM_VARS
$env:PATH_TO_ACM_DIRECTORY
