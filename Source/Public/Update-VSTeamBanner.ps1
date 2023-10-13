function Update-VSTeamBanner {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [string]$Id,

      [string]$Message,

      [ValidateSet('info', 'warning', 'error')]
      [string]$Level,

      [DateTime]$ExpirationDate
   )
   process {
      $existingBanner = Get-VSTeamBanner -Id $Id
      if ($null -eq $existingBanner) { throw "No banner found with ID $Id" }

      $bannerBody = @{
         "GlobalMessageBanners/$Id" = @{
            'level'          = if ($null -ne $Level) { $Level } else { $existingBanner.level }
            'message'        = if ($null -ne $Message) { $Message } else { $existingBanner.message }
            'expirationDate' = if ($null -ne $ExpirationDate) { $ExpirationDate.ToString("yyyy-MM-ddTHH:mm:ss") } else { $existingBanner.expirationDate }
         }
      } | ConvertTo-Json -Depth 3

      Invoke-VSTeamRequest -method PATCH -area 'settings' -resource 'entries/host' -version '3.2-preview' -body $bannerBody
   }
}