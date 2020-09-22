function Get-VSTeamMember {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamMember')]
   param (
      [Parameter()]
      [int] $Top,

      [Parameter()]
      [int] $Skip,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('Name')]
      [Alias('Id')]
      [string] $TeamId,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true )]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      $resp = _callAPI -Resource "projects/$ProjectName/teams" `
         -Id "$TeamId/members" `
         -QueryString @{ '$top' = $top; '$skip' = $skip } `
         -Version $(_getApiVersion Core)

      # Apply a Type Name so we can use custom format view and custom type extensions
      foreach ($item in $resp.value) {
         _applyTypesToTeamMember -item $item -team $TeamId -ProjectName $ProjectName
      }

      Write-Output $resp.value
   }
}