function Show-VSTeamApproval {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('Id')]
      [int] $ReleaseDefinitionId,
      [Parameter(Mandatory=$true, Position = 0 )]
      [ValidateProjectAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      $ProjectName
   )
   process {
      Write-Debug 'Show-VSTeamApproval Process'
      Show-Browser "$(_getInstance)/$ProjectName/_release?releaseId=$ReleaseDefinitionId"
   }
}
