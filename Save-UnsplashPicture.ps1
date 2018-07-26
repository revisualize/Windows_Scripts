function Save-UnsplashPicture () {
    # https://source.unsplash.com/3840x2160/?nature
    # Invoke-WebRequest -Uri 'https://source.unsplash.com/3840x2160/?boat,sail' -UseBasicParsing
        
    $SaveLocation = "D:\Unsplash_Walls\"

    $CategoriesArr = @("water","trees","mountain","sail","snow","lava","ocean","scenic","peak","summit","cloud","sky") | Sort-Object {Get-Random}
    
    $Categories = "nature,"
    $Categories += "$($CategoriesArr[0]),$($CategoriesArr[1])"




    ###########################################

    If (-Not (Test-Path -Path $SaveLocation)) {
        New-Item -Path $SaveLocation -ItemType "directory"
    }
    $Timestamp = Get-Date -Format o | ForEach-Object {$_ -replace ":", "."}
    function Get-DisplayResolution {
        $VideoResX = ((Get-WmiObject -Class Win32_DesktopMonitor | Select-Object ScreenWidth).ScreenWidth)
        $VideoResY = ((Get-WmiObject -Class Win32_DesktopMonitor | Select-Object ScreenHeight).ScreenHeight)
        $VideoResolution = "$VideoResX x $VideoResY" -replace '\s+', ''

        [String]$VideoResolution
    }
    $Resolution = Get-DisplayResolution

    $URL = "https://source.unsplash.com/$($Resolution)/?$Categories"
    $Output = "$SaveLocation$($Timestamp)_$Categories.jpeg" -replace ",","."

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile($URL, $Output)
    [String]$Output
}
Save-UnsplashPicture
