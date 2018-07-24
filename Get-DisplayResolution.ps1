Function Get-DisplayResolution {
    $VideoResX = ((Get-WmiObject -Class Win32_DesktopMonitor | Select-Object ScreenWidth).ScreenWidth)
    $VideoResY = ((Get-WmiObject -Class Win32_DesktopMonitor | Select-Object ScreenHeight).ScreenHeight)
    $VideoResolution = "$VideoResX x $VideoResY" -replace '\s+', ''

    [String]$VideoResolution

}
