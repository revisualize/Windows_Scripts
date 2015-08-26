function Get-DriveSpace {
   [CmdletBinding()]
   param(
      [Parameter(Position=0, 
                 ValueFromPipeline=$true,
                 ValueFromPipelineByPropertyName=$true,
                 Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [Alias('cn', 'host', 'hostname')]
      $ComputerName,

      [Parameter(Mandatory=$false)]
      [Alias('cred', 'login', 'runas')]
      [System.Management.Automation.Credential()]$Credential =
      [System.Management.Automation.PSCredential]::Empty
      )

    ForEach ($Server in $Computername) {
        if ($Credential)
        {
            $GetVolume = Get-WmiObject –ComputerName $Server –Class Win32_Volume -filter "DriveType=3" -Credential $Credential -ErrorAction SilentlyContinue | Where-Object {$_.Label -ne 'System Reserved'} 
        }
        else
        {
            $GetVolume = Get-WmiObject –ComputerName $Server –Class Win32_Volume -filter "DriveType=3" -ErrorAction SilentlyContinue | Where-Object {$_.Label -ne 'System Reserved'} 
        }
        try
        {
            $GetVolume | `
                Format-Table –auto @{Label="Server";Expression={$Server}}, `
                    @{Label="Drive Letter";Expression={$_.DriveLetter}}, `
                    @{Label="Volume Label";Expression={$_.Label}}, `
                    @{Label="Free(GB)  ";Expression={"{0:N3}" –F ($_.FreeSpace/1GB)};alignment="right"}, `
                    @{Label="Size(GB)  ";Expression={"{0:N3}" –F ($_.Capacity/1GB)};alignment="right"}, `
                    @{Label="   % Free";Expression={"{0:P2}" –F ($_.FreeSpace/$_.Capacity)};alignment="right"}
        }
        catch
        {
            Write-Warning "Connecting to $Server failed. ($_.Exeption.Message)"
        }                           
    }

}
