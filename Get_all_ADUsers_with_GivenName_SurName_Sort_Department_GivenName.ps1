Get-ADUser -Filter * -Properties Department, GivenName, SurName, Title, Manager, Enabled | `
    Select-Object Department, `
                  GivenName, `
                  SurName, `
                  Title, `
                  @{Name='Manager';Expression={(Get-ADUser $_.Manager).GivenName + " " + (Get-ADUser $_.Manager).Surname}}, `
                  Enabled | `
         Where-Object {($_.GivenName -ne $null) -and ($_.SurName -ne $null)} | `
         Sort-Object @{Expression='Department'; Ascending=$true } , @{Expression='GivenName'; Ascending=$true } | `
         Format-Table
