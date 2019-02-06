function Get-VSTeamOption {
   [CmdletBinding()]
   param([switch] $Release)

   # Build the url to list the projects
   $params = @{"Method" = "Options"}

   if ($Release.IsPresent) {
      $params.Add("SubDomain", "vsrm")
   }

   # Call the REST API
   $resp = _callAPI @params

   # Apply a Type Name so we can use custom format view and custom type extensions
   foreach ($item in $resp.value) {
      _applyTypes -item $item -type 'Team.Option'
   }

   Write-Output $resp.value
}