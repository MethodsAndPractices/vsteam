function Add-VSTeamBanner {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [string]$Message,

      [Parameter(Mandatory = $true)]
      [ValidateSet('info', 'warning', 'error')]
      [string]$Level,

      [Parameter(Mandatory = $true)]
      [DateTime]$ExpirationDate,

      [string]$Id = (New-Guid).ToString()
   )
   process {
      $bannerBody = @{
         "GlobalMessageBanners/$Id" = @{
            'level'          = $Level
            'message'        = $Message
            'expirationDate' = $ExpirationDate.ToString("yyyy-MM-ddTHH:mm:ss")
         }
      } | ConvertTo-Json -Depth 3

      Invoke-VSTeamRequest -method PATCH -area 'settings' -resource 'entries/host' -version '3.2-preview' -body $bannerBody
   }
}