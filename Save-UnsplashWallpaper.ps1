function Save-UnsplashWallpaper {

    # https://source.unsplash.com/3840x2160/?nature 
    # Invoke-WebRequest -Uri 'https://source.unsplash.com/3840x2160/?boat,sail' -UseBasicParsing 

    # Save location for the image
    $UnsplashImageSaveLocation = "D:\Unsplash_Walls\"

    # Array of possible categories
    $PreferredCategories = @("nature","water","trees","mountain","sail","yacht","snow","lava","ocean","scenic","moon","peak","summit","cloud","sky")

    # Choose two random categories
    $SelectedCategories = (Get-Random -Count 2 -InputObject $PreferredCategories) -join ','

    try {
        # Check if the save location exists and is a directory
        If (-Not (Test-Path -Path $UnsplashImageSaveLocation -PathType Container)) {
            # Save location does not exist or is not a directory
            throw "The specified save location does not exist or is not a directory: $UnsplashImageSaveLocation"
        }

        # Get the current timestamp
        $CurrentTimestamp = Get-Date -Format s | ForEach-Object {$_ -replace ":", "."}

        # Get the display resolution of the current monitor
        function Get-CurrentMonitorResolution {
            try {
                # Get the Win32_DesktopMonitor class
                $Monitor = Get-WmiObject -Class Win32_DesktopMonitor -ErrorAction Stop -ErrorVariable Error

                # Get the screen width and height
                $ScreenWidth = $Monitor.ScreenWidth
                $ScreenHeight = $Monitor.ScreenHeight

                # Validate the input
                If ($ScreenWidth -le 0 -or $ScreenHeight -le 0) {
                    throw "Invalid screen resolution: $ScreenWidth x $ScreenHeight"
                }
  
                $ScreenResolutionXValue = "$ScreenWidth x $ScreenHeight" -replace '\s+', ''

                # Return the screen resolution as a string
                [String] $ScreenResolutionXValue

            } catch {
                # An error occurred
                Write-Error "An error occurred while getting the display resolution: $($Error.Exception.Message)"
            }
        }

        $DesktopResolution = Get-CurrentMonitorResolution

        # Construct the URL for the image
        $URL = "https://source.unsplash.com/$DesktopResolution/?$SelectedCategories"

        # Construct the output file path
        $Output = "$UnsplashImageSaveLocation$CurrentTimestamp-$SelectedCategories.jpeg" -replace ",","."

        try {
            # Download the image from Unsplash
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            $WebClient = New-Object System.Net.WebClient
            $WebClient.DownloadFile($URL, $Output)
        } catch {
            # An error occurred while trying to download the image
            Write-Error "An error occurred while trying to download the image: $($_.Exception.Message)"
        }

    } catch {
        # An error occurred
        Write-Error "An error occurred: $($_.Exception.Message)"
    }
}

Save-UnsplashWallpaper
