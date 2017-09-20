Function Get-ADUserSamAccountName {
    Param(
        [parameter(Mandatory=$true)]
        [String]
        [Alias("F", "First")]
        $FirstName,
    
        [parameter(Mandatory=$true)]
        [String]
        [Alias("L", "Last")]
        $LastName
    )

    return (Get-AdUser -Filter {(GivenName -eq $FirstName) -and (Surname -eq $LastName)} ).SamAccountName

 }
