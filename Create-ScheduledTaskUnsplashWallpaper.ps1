Function Create-ScheduledTaskUnsplashWallpaper {

    $RandomNumber = Get-Random -Minimum 1234 -Maximum 9999

    $TaskName = "1 hour Unsplash Wallpaper $($RandomNumber)"

    $TaskDescription = "One hour timer to Get a new random wallpaper from Save-UnsplashPicture.ps1"

    $TaskExcecute = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"

    $TaskScript = "C:\Users\joseph\OneDrive\Documents\PowerShell\Save-UnsplashPicture.ps1"

    $TaskSettings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit 00:10:00 -RunOnlyIfNetworkAvailable -StartWhenAvailable -DisallowStartOnRemoteAppSession

    $TaskWorkingDirectory = "D:\Unsplash_Walls\"

    $TaskAction = @()
    $TaskAction += New-ScheduledTaskAction -Execute $TaskExcecute -Argument $TaskScript -WorkingDirectory $TaskWorkingDirectory
    $TaskAction += New-ScheduledTaskAction -Execute $TaskExcecute -Argument 'Get-ChildItem -Path "D:\Unsplash_Walls\" -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $((Get-Date).AddDays(-5)) } | Remove-Item -Force' -WorkingDirectory $TaskWorkingDirectory


    $TaskTrigger = New-ScheduledTaskTrigger -Daily -At 1:00:00 -ThrottleLimit 30

    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Settings $TaskSettings -Trigger $TaskTrigger -Description $TaskDescription
}
Create-ScheduledTaskUnsplashWallpaper
