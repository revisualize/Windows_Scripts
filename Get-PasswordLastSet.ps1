Function Get-PasswordLastSet {
    Param(
        [Parameter(Mandatory=$false)]
        [Alias("user", "account")]
        [String]
        $userName
    )

    If (!$userName) {
        Write-Host "Please input the username of the user who you would like to check:"    
        $userName = Read-Host #Stores the username variable
    }
    Import-Module ActiveDirectory
    Get-ADUser -Identity $userName -Properties * | `
        Select-Object Enabled, `
                      GivenName, `
                      Surname, `
                      Name, `
                      SamAccountName, `
                      Title, `
                      Department, `
                      whenCreated, `
                      @{Name="LastLogon TimeStamp";Expression={[datetime]::FromFileTime($_.'lastLogonTimeStamp')}}, `
                      @{Name="Last Logon";Expression={[datetime]::FromFileTime($_.'lastLogon')}}, `
                      PasswordExpired, `
                      PasswordLastSet, `
                      badPwdCount, `
                      LastBadPasswordAttempt, `
                      @{Name="badPasswordTime";Expression={[datetime]::FromFileTime($_.'badPasswordTime')}}, `
                      @{Name='Manager';Expression={(Get-ADUser $_.Manager).GivenName + " " + (Get-ADUser $_.Manager).Surname}}

    

    Clear-Variable userName
}
