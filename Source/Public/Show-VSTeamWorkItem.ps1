function Show-VSTeamWorkItem {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [Alias('WorkItemID')]
      [int] $Id,
      
      [Parameter(Mandatory = $true, Position = 0)]
      [ValidateProjectAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      $ProjectName
   )
   
   process {
      Show-Browser "$(_getInstance)/$ProjectName/_workitems/edit/$Id"
   }
}
