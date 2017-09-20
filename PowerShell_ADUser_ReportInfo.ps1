#Reporting Scripts

Get-ADUser `
    #-SearchBase 'REMOVED_FOR_SECURITY' `
    -Filter {Enabled -eq $true} -Properties * | `
    Where-Object "targetAddress" -ne $null | `
    Where-Object "PasswordNeverExpires" -ne $true | `
    Select-Object GivenName, `
                  Surname, `
                  SamAccountName, `
                  EmailAddress, `
                  targetAddress, `
                  Title, `
                  Department, `
                  @{Name="LastLogon TimeStamp";Expression={[datetime]::FromFileTime($_.'lastLogonTimeStamp')}}, `
                  @{Name="Last Logon";Expression={[datetime]::FromFileTime($_.'lastLogon')}}, `
                  # PasswordExpired, `
                  whenCreated, `
                  @{Name='Manager';Expression={(Get-ADUser $_.Manager).GivenName + " " + (Get-ADUser $_.Manager).Surname}} | `
    Where-Object "GivenName" -ne $null | `
    Where-Object "SurName" -ne $null |`
    Sort-Object @{Expression='GivenName'; Ascending=$true } | `
    Format-Table
    #Export-Csv "C:\DIRECTORY\DATE_FILE-NAME.csv"
