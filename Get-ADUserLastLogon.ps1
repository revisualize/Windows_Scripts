Get-ADUser -Filter {Enabled -eq $true} -Properties * | `
     Select-Object GivenName, `
                   Surname, `
                   SamAccountName, `
                   Department, `
                   @{Name="LastLogon TimeStamp";Expression={[datetime]::FromFileTime($_.'lastLogonTimeStamp')}}, `
                   @{Name="Last Logon";Expression={[datetime]::FromFileTime($_.'lastLogon')}}, `
                   PasswordExpired, `
                   PasswordLastSet, `
                   @{Name='Manager';Expression={(Get-ADUser $_.Manager).GivenName + " " + (Get-ADUser $_.Manager).Surname}} | `
     Sort-Object "Last Logon" | `
     Format-Table
