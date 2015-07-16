."C:\servers.ps1"

<#
$machinelist = "server01", 
               "server02", 
               "server03", 
               "server04", 
               "server05", 
               "server06"
#>

$ShareDrive = "\c$\Logs"
$ShareDir = "C:\Logs"
$ShareName = "Logs"
$ShareGroup = "DOMAIN\USERGROUP"
$NetSharePerm = "$ShareGroup,Read"

$PSEXEC_u_p = ""                        #  Should be cleared to "" if you're not using a username and password
$PSEXEC_Bat_Loc = "C:\PSEXECLogShare.bat"


# =--- This is using powershell to create a batch file. Because running PSEXEC in PS is a headache.
# =--- This would be a lot easier if the machines had access to INVOKE-COMMAND:
# Invoke-Command -ComputerName $machine -ScriptBlock {net share $ShareName=$ShareDir /grant:$NetSharePerm /cache:none /unlimited"}



Function Create-PSEXECBatchFile
{
    ForEach ($machine in $machinelist)
    {
        if ((Test-Path "\\$machine$ShareDrive") -AND !(Get-WmiObject -Class Win32_Share -ComputerName $machine -Filter "Name='$ShareName'"))
        {

            "psexec \\$machine $PSEXEC_u_p cmd /c net share $ShareName=$ShareDir /grant:$NetSharePerm /cache:none /unlimited" | Out-File -FilePath $PSEXEC_Bat_Loc -Encoding ascii -Append
        
        }
        else
        {
            Get-WmiObject -Class Win32_Share -ComputerName $machine -Filter "Name='$ShareName'" | Select-Object Name, Path, Description, PSComputername
        }
    }
}


Function Clear-PSEXECBatchFile
{
    "" | Out-File -FilePath $PSEXEC_Bat_Loc -Encoding ascii
}


Function Get-LogShare
{
    ForEach ($machine in $machinelist)
    {
        Get-WmiObject -Class Win32_Share -ComputerName $machine -Filter "Name='$ShareName'" |
         Select-Object Name, Path, Description, PSComputername |
          Sort-Object PSComputerName
    }
}


Function Delete-LogShare
{
    ForEach ($machine in $machinelist)
    {
        $share = Get-WmiObject -Class Win32_Share `
         -ComputerName $machine `
          -Filter "Name='$Sharename'"
        $share.delete()
    }
}


Function Get-LogSharePermission
{
    ForEach ($machine in $machinelist)
    {
        (Get-WmiObject -ComputerName $machine `
           -class Win32_logicalShareSecuritySetting `
              -Filter "Name='$ShareName'").GetSecurityDescriptor().Descriptor.DACL.Trustee |
                 Select-Object Domain, Name
    }
}




Function Set-SecurityPermissions
{
    ForEach ($machine in $machinelist)
    {
        $acl = Get-Acl "\\$machine$ShareDrive"
        $permission = "$ShareGroup","Read","Allow"
        $accessRule = New-Object `
            System.Security.AccessControl.FileSystemAccessRule `
                $permission
        $acl.SetAccessRule($accessRule)
        $acl |
            Set-Acl "\\$machine$ShareDrive"
    }
}
