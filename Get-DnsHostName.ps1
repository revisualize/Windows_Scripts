Function Get-DnsHostName {

    Param (
        [Parameter(Mandatory=$True,
                   HelpMessage="Enter a ComputerName"
                   )] 
                   [string]
                   [Alias("cn","comp","ComputerName")]
                   $Host
    )

   Return [System.Net.Dns]::GetHostByAddress( [System.Net.Dns]::GetHostByName($ComputerName).AddressList.IpAddressToString ).HostName
 }
