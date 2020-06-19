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
      [string] $TeamId,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true )]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      $resp = _callAPI -Id "$TeamId/members" -Area 'projects' -Resource "$ProjectName/teams" -Version $(_getApiVersion Core) `
         -QueryString @{'$top' = $top; '$skip' = $skip}

      # Apply a Type Name so we can use custom format view and custom type extensions
      foreach ($item in $resp.value) {
         _applyTypesToTeamMember -item $item -team $TeamId -ProjectName $ProjectName
      }

      Write-Output $resp.value
   }
}