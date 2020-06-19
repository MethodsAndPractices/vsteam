function Show-VSTeamProject {
   [CmdletBinding(DefaultParameterSetName = 'ByName')]
   param(
      [Parameter(ParameterSetName = 'ByID')]
      [Alias('ProjectID')]
      [string] $Id,

      [Parameter(ParameterSetName = 'ByName', Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter]) ]
      [Alias('ProjectName')]
      [string] $Name
   )

   process {
      _hasAccount

      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["Name"]

      if ($id) {
         $ProjectName = $id
      }

      Show-Browser "$(_getInstance)/$ProjectName"
   }
}
