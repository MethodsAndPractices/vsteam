function Show-VSTeamProject {
   [CmdletBinding(DefaultParameterSetName = 'ByName')]
   param(
      [Parameter(ParameterSetName = 'ByID')]
      [Alias('ProjectID')]
      [string] $Id
   )

   DynamicParam {
      _buildProjectNameDynamicParam -ParameterSetName 'ByName' -ParameterName 'Name' -AliasName 'ProjectName'
   }

   process {
      _hasAccount

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["Name"]

      if ($id) {
         $ProjectName = $id
      }

      Show-Browser "$([VSTeamVersions]::Account)/$ProjectName"
   }
}