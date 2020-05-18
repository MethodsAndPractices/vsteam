function Get-VSTeamOption {
   [CmdletBinding()]
   param(
      [string] $subDomain,

      [Parameter(Position = 0)]
      [Alias("Service")]
      [string] $area,

      [Parameter(Position = 1)]
      [string] $resource
   )

   # Build the url to list the projects
   $params = @{ "Method" = "Options" }

   if ($subDomain) {
      $params.Add("SubDomain", $subDomain)
   }

   if ($area) {
      $params.Add("Area", $area)
   }

   if ($resource) {
      $params.Add("Resource", $resource)
   }

   # Call the REST API
   $resp = _callAPI @params

   # Apply a Type Name so we can use custom format view and custom type extensions
   foreach ($item in $resp.value) {
      _applyTypes -item $item -type 'Team.Option'
   }

   Write-Output $resp.value
}