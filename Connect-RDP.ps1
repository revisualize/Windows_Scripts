Function Connect-RDP {
    Param (
        [Parameter(Mandatory=$True,
                   HelpMessage="Enter a ComputerName"
                   )] 
                   [string]
                   [Alias("cn","comp")]
                   $ComputerName
    )

    Function Get-DnsHostName {

        Param (
            [Parameter(Mandatory=$True,
                       HelpMessage="Enter a ComputerName"
                       )] 
                       [string]
                       [Alias("cn","comp","ComputerName")]
                       $Host
        )

        Return [System.Net.Dns]::GetHostByAddress( [System.Net.Dns]::GetHostByName($Host).AddressList.IpAddressToString ).HostName
    }
    
    $ServerHostName = Get-DnsHostName -Host $ComputerName
    
    Start-Process "$env:windir\system32\mstsc.exe" -ArgumentList "/v:$ServerHostName"
    
}
