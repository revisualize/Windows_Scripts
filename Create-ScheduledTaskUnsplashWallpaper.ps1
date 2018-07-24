Function Create-ScheduledTaskUnsplashWallpaper {



    $TaskWorkingDirectory = "D:\Unsplash_Walls\"

    $TaskScript = "C:\Users\joseph\OneDrive\Documents\PowerShell\Save-UnsplashPicture.ps1"





    $RandomNumber = Get-Random -Minimum 1234 -Maximum 9999

    $TaskName = "1 hour Unsplash Wallpaper $($RandomNumber)"

    $TaskDescription = "One hour timer to Get a new random wallpaper from Save-UnsplashPicture.ps1"

    $TaskExcecute = "Powershell.exe"

    $TaskSettings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit 00:10:00 -RunOnlyIfNetworkAvailable -StartWhenAvailable -DisallowStartOnRemoteAppSession

    $TaskDeleteFiles = 'Get-ChildItem -Path ' 
    $TaskDeleteFiles += $TaskWorkingDirectory
    $TaskDeleteFiles += ' -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt \$((Get-Date).AddDays(-5)) } | Remove-Item -Force'
    
    $TaskAction = @()
    $TaskAction += New-ScheduledTaskAction -Execute $TaskExcecute -Argument $TaskScript -WorkingDirectory $TaskWorkingDirectory
    $TaskAction += New-ScheduledTaskAction -Execute $TaskExcecute -Argument $TaskDeleteFiles -WorkingDirectory $TaskWorkingDirectory

    $TaskAction
    $TaskTrigger = New-ScheduledTaskTrigger -Daily -At 1:00:00 -ThrottleLimit 30

    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Settings $TaskSettings -Trigger $TaskTrigger -Description $TaskDescription
}
Create-ScheduledTaskUnsplashWallpaper
