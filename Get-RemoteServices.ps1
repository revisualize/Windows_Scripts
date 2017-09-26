Function Get-RemoteServices {
    [CmdletBinding()]
    Param(
            [Parameter(Mandatory=$True)]
            [string]$ComputerName
          )
    Try {
        If ([bool](Get-ADComputer -Identity $ComputerName)) {
            Get-WmiObject Win32_service -ComputerName $ComputerName | `
                Where-Object {$_.StartMode -ne "Disabled"} | `
                    Format-Table DisplayName, Name, State, StartMode, Status, StartName, ServiceType, SystemName
        }
    }
    Finally {
        Clear-Variable ComputerName
    }
}
