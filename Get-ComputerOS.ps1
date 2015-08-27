function Get-ComputerOS {
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


    ForEach ($Computer in $Computername) {
        if ($Credential)
            {
                $OS = (Get-WmiObject -Computer $Computer -Class Win32_OperatingSystem -Credential $Credential).version
            }
        else
            {
                $OS = (Get-WmiObject -Computer $Computer -Class Win32_OperatingSystem).version
            }
        switch ($OS)
            {
                5.0.2195 {"Windows 2000"; break}
                5.1.2600 {"Windows XP or Windows XP 64-Bit Edition Version 2002 (Itanium)"; break}
                5.2.3790 {"Windows Server 2003 or Windows XP x64 Edition (AMD64/EM64T) or Windows XP 64-Bit Edition Version 2003 (Itanium)"; break}
                6.0.6000 {"Windows Vista"; break}
                6.0.6001 {"Windows Vista with Service Pack 1 or Windows Server 2008"; break}
                6.1.7600 {"Windows 7 or Windows Server 2008 R2"; break}
                6.1.7601 {"Windows 7 with Service Pack 1 or Windows Server 2008 R2 with Service Pack 1"; break}
                6.2.9200 {"Windows 8 or Windows Server 2012"; break}
                6.3.9200 {"Windows 8.1 or Windows Server 2012 R2"; break}
                6.3.9600 {"Windows 8.1 with Update 1"; break}
                10.0.10240 {"Windows 10"; break}
                default {"Something failed. May need to re-try with the -Credential parameter."; break}
            }
    }
}
