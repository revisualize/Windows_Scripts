function Invoke-GetTime
{
    <#
        .EXAMPLE
           PS C:\> Invoke-GetTime -dc dc1.domain.local
    #>
    param(
            [Parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [System.String]
            [Alias('dc', 'ts', 'timeserver')]
            $DomainController
        )
    
    foreach ($i in Get-NetView)
    {
        Get-TimeDiff -ComputerName $i -DomainController $DomainController
    }

}


function Get-Time 
{
   <#
      .SYNOPSIS
         Gets the time of a windows server
 
      .DESCRIPTION
         Uses WMI to get the time of a remote server
 
      .PARAMETER  ServerName
         The Server to get the date and time from
 
      .EXAMPLE
         PS C:\> Get-Time localhost
 
      .EXAMPLE
         PS C:\> Get-Time server01.domain.local -Credential (Get-Credential)
 
   #>
   [CmdletBinding()]
   param(
      [Parameter(Position=0, Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
      [System.String]
      [Alias('cn', 'host', 'hostname')]
      $ComputerName,
 
      $Credential
   )

         if ($Credential) 
         {
            $CT = Get-WmiObject -Class Win32_LocalTime -ComputerName $ComputerName -Credential $Credential -ErrorAction SilentlyContinue 
         } 
         else 
         {
            $CT = Get-WmiObject -Class Win32_LocalTime -ComputerName $ComputerName -ErrorAction SilentlyContinue 
         }

   New-Object PSObject -Property @{
      ServerName = $CT.__Server
      DateTime = (Get-Date -Month $CT.Month -Day $CT.Day -Year $CT.Year -Minute $CT.Minute -Hour $CT.Hour -Second $CT.Second)
   }
    
}


function Get-NetView 
{
	switch -regex (NET.EXE VIEW) { "^\\\\(?<Name>\S+)\s+" {$matches.Name}}
}



function Get-TimeDiff
{
    param
    (
            [Parameter(Mandatory=$true)]
            [Alias('cn', 'host', 'hostname')]
            $ComputerName,

            [Parameter(Mandatory=$true)]
            [Alias('dc', 'ts', 'timeserver')]
            $DomainController
    )
    try
    {
        $ComputerTime = Get-Time -ComputerName $ComputerName
        $DCServerTime = Get-Time -ComputerName $DomainController

        if ($ComputerTime)
        {
            $Diff = $ComputerTime.DateTime - $DCServerTime.DateTime
            if (($Diff.TotalSeconds -gt 5) -or ($Diff.TotalSeconds -lt -5))
            {
            Write-Host "$ComputerName :: $Diff" -foreground white -BackgroundColor red
            }
            else
            {
            Write-Host "$ComputerName :: $Diff" 
            }
        }
    }
    catch
    {
        Write-Error "Connecting to $ComputerName failed."

    }

}
