function Show-VSTeamBuild {
   [CmdletBinding(DefaultParameterSetName = 'ByID')]
   param (
      [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [int[]] $Id
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      Show-Browser "$(_getInstance)/$ProjectName/_build/index?buildId=$Id"
   }
}