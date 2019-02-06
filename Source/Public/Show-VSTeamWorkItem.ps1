function Show-VSTeamWorkItem {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
      [Alias('WorkItemID')]
      [int] $Id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      Show-Browser "$([VSTeamVersions]::Account)/$ProjectName/_workitems/edit/$Id"
   }
}