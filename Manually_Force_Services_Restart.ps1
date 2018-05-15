$Creds = Get-Credential -Message "Elevated Credentials are required for restarting services on remote workstations."

$C_Computers = @()

$Service_Name = "Monitor Service"
$Service_Exe = 'service.exe'

$LogFile_Path = "C:\Windows\Temp\Monitor_Service_Script_Execution.log"

foreach ($computer in $C_Computers) {

    $Service_Info = (Get-WmiObject -Class Win32_Service -ComputerName $computer -Filter "name = '$Service_Name'" -Credential $Creds)
 
    If (($Service_Info.StartMode) -ne "Disabled") {
        If ((($Service_Info.State) -eq "Stopped")) {
            Write-Host -ForegroundColor Red "$Service_Name on $computer is $(($Service_Info).State)"
            Write-Host -ForegroundColor Red "$Service_Name on $computer is $(($Service_Info).StartMode)"
            Write-Host -ForegroundColor Green "Starting $Service_Name on $computer"
            Invoke-Command -ComputerName $computer -ScriptBlock { Add-Content -Path $args[0] -Value "$(Get-Date -Format "yyyy/MM/dd hh:mm:ss") $($args[1]) is $($args[2]) | Starting Service" } -ArgumentList $LogFile_Path, $Service_Name, $Service_Info.State -Credential $Creds
            ($Service_Info.StartService() | Select PSComputerName)
        } 
        ElseIf ((($Service_Info.State) -eq "Stopping") -or (($Service_Info.State) -eq "Starting") ) {
            Write-Host -ForegroundColor Red "$Service_Name on $computer is $(($Service_Info).State) state"
            Write-Host -ForegroundColor Red "$Service_Name $Service_Exe on $computer will be terminated"
        
            Invoke-Command -ComputerName $computer -ScriptBlock { Add-Content -Path $args[0] -Value "$(Get-Date -Format "yyyy/MM/dd hh:mm:ss") $($args[1]) is $($args[2]) | Terminating the $($args[3]) Process" } -ArgumentList $LogFile_Path, $Service_Name, $Service_Info.State, $Service_Exe -Credential $Creds

            (Get-WmiObject -Class Win32_Process -ComputerName $computer -Filter "name = '$Service_Exe'" -Credential $Creds).Terminate()

            Invoke-Command -ComputerName $computer -ScriptBlock { Add-Content -Path $args[0] -Value "$(Get-Date -Format "yyyy/MM/dd hh:mm:ss") $($args[1]) is $((Get-Service -Name $args[1]).Status) | Terminated the $($args[2]) Process" } -ArgumentList $LogFile_Path, $Service_Name, $Service_Exe -Credential $Creds
        
            Start-Sleep -Milliseconds 500
            Write-Host -ForegroundColor Green "Starting $Service_Name on $computer"
            Invoke-Command -ComputerName $computer -ScriptBlock { Add-Content -Path $args[0] -Value "$(Get-Date -Format "yyyy/MM/dd hh:mm:ss") $($args[1]) is $($args[2]) | Starting Service" } -ArgumentList $LogFile_Path, $Service_Name, $Service_Info.State -Credential $Creds
            ($Service_Info.StartService() | Select PSComputerName)
        }
        ElseIf (($Service_Info.State) -eq "Running" ) {
            Write-Host -ForegroundColor Green "$Service_Name on $computer is $($Service_Info.State)"
            Write-Host -ForegroundColor Green "Restarting $Service_Name on $computer"
            (($Service_Info).StopService() | Select PSComputerName)
            Start-Sleep -Seconds 1
            (($Service_Info).StartService() | Select PSComputerName)
        }  
        Start-Sleep -Seconds 3

        Invoke-Command -ComputerName $computer -ScriptBlock { Add-Content -Path $args[0] -Value "$(Get-Date -Format "yyyy/MM/dd hh:mm:ss") $($args[1]) is $((Get-Service -Name $args[1]).Status)" } -ArgumentList $LogFile_Path, $Service_Name -Credential $Creds
        Write-Host "$Service_Name on $computer is: $((Get-WmiObject -Class Win32_Service -ComputerName $computer -Filter "name = '$Service_Name'" -Credential $Creds).State)"
        Write-Host "--------"
    }
}

Remove-Variable -Name Creds
Remove-Variable -Name C_Computers
Remove-Variable -Name Service_Name
Remove-Variable -Name Service_Exe
Remove-Variable -Name computer
Remove-Variable -Name Service_Info
Remove-Variable -Name LogFile_Path

Pause
