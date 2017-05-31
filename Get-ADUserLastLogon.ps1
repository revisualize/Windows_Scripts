Get-ADUser -Filter {Enabled -eq $true} -Properties * | `
     Select-Object GivenName, `
                   Surname, `
                   SamAccountName, `
                   Title, `
                   Department, `
                   @{Name="LastLogon TimeStamp";Expression={[datetime]::FromFileTime($_.'lastLogonTimeStamp')}}, `
                   @{Name="Last Logon";Expression={[datetime]::FromFileTime($_.'lastLogon')}}, `
                   PasswordExpired, `
                   whenCreated, `
                   @{Name='Manager';Expression={(Get-ADUser $_.Manager).GivenName + " " + (Get-ADUser $_.Manager).Surname}} | `
     Sort-Object @{Expression='Department'; Ascending=$true } , @{Expression='SamAccountName'; Ascending=$true } | `
     Format-Table
