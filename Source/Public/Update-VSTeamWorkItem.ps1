function Update-VSTeamWorkItem {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int] $Id,

      [Parameter(Mandatory = $false)]
      [string]$Title,

      [Parameter(Mandatory = $false)]
      [string]$Description,

      [Parameter(Mandatory = $false)]
      [string]$IterationPath,

      [Parameter(Mandatory = $false)]
      [string]$AssignedTo,

      [Parameter(Mandatory = $false)]
      [string]$Tag,

      [switch] $Force
   )

   Process {

      if ($Tag.Length -ge 1) {
         # Get existing tags (if any) so we do not lose them
         # when calling the api with PATCH.
         # Then add on the value in $Tag
         $Tags = "$((Get-VSTeamWorkItem -Id $Id).Tags);$($Tag)"
      }
      # Constructing the contents to be sent.
      # Empty parameters will be skipped when converting to json.
      $body = @(
         @{
            op    = "add"
            path  = "/fields/System.Title"
            value = $Title
         }
         @{
            op    = "add"
            path  = "/fields/System.Description"
            value = $Description
         }
         @{
            op    = "add"
            path  = "/fields/System.IterationPath"
            value = $IterationPath
         }
         @{
            op    = "add"
            path  = "/fields/System.AssignedTo"
            value = $AssignedTo
         }
         @{
            op    = "add"
            path  = "/fields/System.Tags"
            value = $Tags
         }) | Where-Object { $_.value}

      # It is very important that even if the user only provides
      # a single value above that the item is an array and not
      # a single object or the call will fail.
      # You must call ConvertTo-Json passing in the value and not
      # not using pipeline.
      # https://stackoverflow.com/questions/18662967/convertto-json-an-array-with-a-single-item
      $json = ConvertTo-Json @($body) -Compress

      # Call the REST API
      if ($Force -or $pscmdlet.ShouldProcess($Id, "Update-WorkItem")) {
         $resp = _callAPI -Area 'wit' -Resource 'workitems' `
            -Version $([VSTeamVersions]::Core) -id $Id -Method Patch `
            -ContentType 'application/json-patch+json' -Body $json

         _applyTypesToWorkItem -item $resp

         return $resp
      }
   }
}