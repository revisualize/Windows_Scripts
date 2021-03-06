Function Create-ScheduledTaskUnsplashWallpaper {



    $TaskWorkingDirectory = "D:\Unsplash_Walls\"

    $TaskScript = "C:\Users\joseph\OneDrive\Documents\PowerShell\Save-UnsplashPicture.ps1"





    $RandomNumber = Get-Random -Minimum 1234 -Maximum 9999

    $TaskName = "1 hour Unsplash Wallpaper $($RandomNumber)"

    $TaskDescription = "One hour timer to Get a new random wallpaper from Save-UnsplashPicture.ps1"

    $TaskRepetition = (New-TimeSpan -Minutes 60)
    $TaskDuration = ([timeSpan]::maxvalue)

    $TaskExecute = $pshome
    $TaskExecute += "\powershell.exe"

    $TaskSettings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit 00:10:00 -RunOnlyIfNetworkAvailable -StartWhenAvailable -DisallowStartOnRemoteAppSession

    $TaskDeleteFiles = 'Get-ChildItem -Path ' 
    $TaskDeleteFiles += $TaskWorkingDirectory
    $TaskDeleteFiles += ' -Recurse -Force | Where-Object { !$_.PSIsContainer -and ($_.CreationTime -lt $((Get-Date).AddDays(-15)) -or ($_.Length -lt 275kb)) } | Remove-Item -Force'
    
    $TaskDeleteDuplicates = 'Get-ChildItem -Path '
    $TaskDeleteDuplicates += $TaskWorkingDirectory
    $TaskDeleteDuplicates += ' -Recurse -Force | Get-FileHash | Group-Object -Property Hash | Where-Object {$_.count -gt 1 } | % { $_.group | Select-Object -Skip 1} | Remove-Item -Force' 

    $TaskAction = @()
    $TaskAction += New-ScheduledTaskAction -Execute $TaskExecute -Argument "-nologo -windowstyle Hidden $($TaskScript)" -WorkingDirectory $TaskWorkingDirectory
    $TaskAction += New-ScheduledTaskAction -Execute $TaskExecute -Argument "-nologo -windowstyle Hidden $($TaskDeleteFiles)" -WorkingDirectory $TaskWorkingDirectory
    $TaskAction += New-ScheduledTaskAction -Execute $TaskExecute -Argument "-nologo -windowstyle Hidden $($TaskDeleteDuplicates)" -WorkingDirectory $TaskWorkingDirectory

    $TaskRepetition = (New-TimeSpan -Minutes 60)
    $TaskDuration = (New-TimeSpan -Days 20000)    #54.8 years 

    $TaskTrigger = New-ScheduledTaskTrigger -Once -At (Get-Date).Date -RepetitionInterval $TaskRepetition -RepetitionDuration $TaskDuration
    #New-ScheduledTaskTrigger -Daily -At 1:00:00 -ThrottleLimit 30
    
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Settings $TaskSettings -Trigger $TaskTrigger -Description $TaskDescription
}
Create-ScheduledTaskUnsplashWallpaper
