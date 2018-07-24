Get-ChildItem -Path "D:\Unsplash_Walls\" -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $((Get-Date).AddDays(-5)) } | Remove-Item -Force
