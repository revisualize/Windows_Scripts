Function Verify-ADUser {
    <#
        .SYNOPSIS
        Verifies if an Active Directory User exists via firstname and lastname

        .DESCRIPTION
        The Verify-ADUser cmdlet returns a boolean value (True / False) if an Active Directory User exists with the same First Name and Last Name
    #>
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

    [bool](Get-ADUser -filter {GivenName -eq $FirstName -and Surname -eq $LastName})
}
