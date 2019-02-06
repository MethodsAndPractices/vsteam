function Get-VSTeamBuildDefinition {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [string] $Filter,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('build', 'xaml', 'All')]
      [string] $Type = 'All',

      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildDefinitionID')]
      [int[]] $Id,

      [Parameter(ParameterSetName = 'ByID')]
      [int] $Revision
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($id) {
         foreach ($item in $id) {
            $resp = _callAPI -ProjectName $ProjectName -Id $item -Area build -Resource definitions -Version $([VSTeamVersions]::Build) `
               -QueryString @{revision = $revision}

            $item = [VSTeamBuildDefinition]::new($resp, $ProjectName)

            Write-Output $item
         }
      }
      else {
         $resp = _callAPI -ProjectName $ProjectName -Area build -Resource definitions -Version $([VSTeamVersions]::Build) `
            -QueryString @{type = $type; name = $filter; includeAllProperties = $true}

         $objs = @()

         foreach ($item in $resp.value) {
            $objs += [VSTeamBuildDefinition]::new($item, $ProjectName)
         }

         Write-Output $objs
      }
   }
}