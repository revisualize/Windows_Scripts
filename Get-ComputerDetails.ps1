Function Get-ComputerDetails
   {
    [cmdletbinding()]
    Param([string[]]$Computer)
    $msg = ""
    foreach ($node in $Computer)
       {
          try
           {
             $sys = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $node -ErrorAction Stop
             $bios = Get-WmiObject -Class Win32_Bios -ComputerName $node -ErrorAction Stop
             [pscustomobject][ordered]@{
                Name = $sys.Name
                Manufacturer = $sys.Manufacturer
                Model = $sys.Model
                Serial = $bios.SerialNumber
             }
           }
          catch
           {
             $msg += "The command failed for computer $node. Message: $_.Exception.Message`r`n"
             continue
           }
       }
       if ("" -ne $msg) { Write-Error -Message $msg }
  }
