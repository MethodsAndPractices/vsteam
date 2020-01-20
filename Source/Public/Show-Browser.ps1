function Show-Browser {
    [Alias('sb')]
    param(
       [parameter(Mandatory = $true)]
       [string] $url
    )
 
    Write-Verbose "Open browser to $url"
 
    if     ($IsLinux) {Start-Process -FilePath xdg-open -Args "$url" }
    elseif ($IsMacOS) {Start-Process -FilePath open -Args "$url"}
    else              {Start-Process $url }
 }
