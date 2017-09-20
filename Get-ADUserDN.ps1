Function Get-ADUserDN {
    Param(
        [parameter(Mandatory=$true)]
        [String]
        [Alias("N")]
        $Name
    )
    $firstName = $Name.Split(" ")[0]
    $lastName = $Name.Split(" ")[1]
    return (Get-ADUser -Filter {GivenName -eq $firstName -and SurName -eq $lastName}).DistinguishedName
}
