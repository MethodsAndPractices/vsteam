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

      [Parameter(Mandatory=$true, Position = 0, ValueFromPipelineByPropertyName = $true )]
      [ValidateProjectAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      $ProjectName
   )
   process {
      $resp = _callAPI -Id "$TeamId/members" -Area 'projects' -Resource "$ProjectName/teams" -Version $(_getApiVersion Core) `
            -QueryString @{'$top' = $top; '$skip' = $skip}

   # Apply a Type Name so we can use custom format view and custom type extensions
      foreach ($item in $resp.value) {
         $item | Add-Member -MemberType NoteProperty -Name Team -Value $TeamId
         $item | Add-Member -MemberType NoteProperty -Name ProjectName -Value $ProjectName
         $item.PSObject.TypeNames.Insert(0, 'Team.TeamMember')
      }

      Write-Output $resp.value
    }
}
