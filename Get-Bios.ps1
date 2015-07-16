function Get-Bios {
    [CmdletBinding()]
    param(
        [String]$ComputerName='localhost'
    )
    Get-WmiObject -class win32_bios -ComputerName $ComputerName
}
