Function Migrate-ADGroupMembers {
    <#
    .NAME
    Migrate-ADGroupMembers
    
    .SYNOPSIS
    Migrates one or more members from a current Active Directory group to another Active Directory Group
    #>
    Param(
        [Parameter(Mandatory=$true)]
        [Alias("F", "Source")]
        [String]$From,

        [Parameter(Mandatory=$true)]
        [Alias("T", "Destination", "Dest")]
        [String]$To,

        [Parameter(Mandatory=$false)]
        [String]$WhatIf
    )

    $Error.Clear()
	
    $FromGroupDN = (Get-ADGroupMember -Identity $From).DistinguishedName
    $ToGroupDN = (Get-ADGroupMember -Identity $To).DistinguishedName	
    Write-Host "Found "($FromGroupDN.count)" members in $From Group."
	Write-Host "Found "($ToGroupDN.count)" members in $To Group."

    If ($FromGroupDN.count -gt 0) {
            Add-ADGroupMember `
                    -Identity $ToGroupDN `
                    -Members $FromGroupDN | `
                              Select -ExpandProperty distinguishedName -WhatIf:([bool]$WhatIf)
    }
    Else {
        Write-Host "$From Security Group has " ($FromGroupDN.count) " members"
    }
    If ($FromGroupDN.count -LT $ToGroupDN.count) {
        Write-Host -ForegroundColor Red -BackgroundColor Black "MISMATCH IN MEMBERSHIP COUNT"
        $FromMembers = Get-ADGroupMember -Identity $From
        $ToMembers = Get-ADGroupMember -Identity $To
        Compare-Object $FromMembers $ToMembers -Property Name
    }
}
