function Get-VSTeamWorkItem {
   [CmdletBinding(DefaultParameterSetName = 'ByID')]
   param(
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int] $Id,

      [Parameter(ParameterSetName = 'List', Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int[]] $Ids,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('Fail', 'Omit')]
      [string] $ErrorPolicy = 'Fail',

      [ValidateSet('None', 'Relations', 'Fields', 'Links', 'All')]
      [string] $Expand = 'None',

      [string[]] $Fields
   )

   Process {
      # Call the REST API
      if ($Ids) {
         $resp = _callAPI -Area 'wit' -Resource 'workitems'  `
            -Version $([VSTeamVersions]::Core) `
            -Querystring @{
            '$Expand'   = $Expand
            fields      = ($Fields -join ',')
            errorPolicy = $ErrorPolicy
            ids         = ($ids -join ',')
         }

         foreach ($item in $resp.value) {
            _applyTypesToWorkItem -item $item
         }
      }
      else {
         $a = $id[0]
         $resp = _callAPI -Area 'wit' -Resource 'workitems'  `
            -Version $([VSTeamVersions]::Core) -id "$a" `
            -Querystring @{
            '$Expand' = $Expand
            fields    = ($Fields -join ',')
         }

         _applyTypesToWorkItem -item $resp
      }

      return $resp
   }
}