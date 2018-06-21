Get-ADObject -Filter * -Properties CanonicalName,ProtectedFromAccidentalDeletion |
    Where-Object {$_.ProtectedFromAccidentalDeletion -eq $false -and $_.ObjectClass -eq "organizationalUnit"} | 
    Select-Object CanonicalName,ProtectedFromAccidentalDeletion |
    # Set-ADObject -ProtectedFromAccidentalDeletion $True
    Format-Table
