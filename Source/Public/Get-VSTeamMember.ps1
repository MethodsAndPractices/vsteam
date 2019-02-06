function Get-VSTeamMember {
   [CmdletBinding()]
   param (
      [Parameter()]
      [int] $Top,

      [Parameter()]
      [int] $Skip,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('Name')]
      [Alias('Id')]
      [string] $TeamId
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $resp = _callAPI -Id "$TeamId/members" -Area 'projects' -Resource "$ProjectName/teams" -Version $([VSTeamVersions]::Core) `
         -QueryString @{'$top' = $top; '$skip' = $skip}

      # Apply a Type Name so we can use custom format view and custom type extensions
      foreach ($item in $resp.value) {
         _applyTypesToTeamMember -item $item -team $TeamId -ProjectName $ProjectName
      }

      Write-Output $resp.value
   }
}