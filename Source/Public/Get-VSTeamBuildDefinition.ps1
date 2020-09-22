function Get-VSTeamBuildDefinition {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamBuildDefinition')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [string] $Filter,

      [Alias('BuildDefinitionID')]
      [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'ByIdRaw')]
      [Parameter(Position = 0, ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [int[]] $Id,

      [Parameter(ParameterSetName = 'ByID')]
      [Parameter(ParameterSetName = 'ByIdRaw')]
      [int] $Revision,

      [switch] $JSON,

      [Parameter(Mandatory = $true, ParameterSetName = 'ByIdRaw')]
      [switch] $raw,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      if ($id) {
         foreach ($item in $id) {
            $resp = _callAPI -ProjectName $ProjectName `
               -Area build `
               -Resource definitions `
               -Id $item `
               -QueryString @{revision = $revision } `
               -Version $(_getApiVersion Build)

            if ($JSON.IsPresent) {
               $resp | ConvertTo-Json -Depth 99
            }
            else {
               if (-not $raw.IsPresent) {
                  $item = [vsteam_lib.BuildDefinition]::new($resp, $ProjectName)

                  Write-Output $item
               }
               else {
                  Write-Output $resp
               }
            }
         }
      }
      else {
         $resp = _callAPI -ProjectName $ProjectName `
            -Area build `
            -Resource definitions `
            -Version $(_getApiVersion Build) `
            -QueryString @{name = $filter; includeAllProperties = $true }

         if ($JSON.IsPresent) {
            $resp | ConvertTo-Json -Depth 99
         }
         else {
            $objs = @()

            foreach ($item in $resp.value) {
               $objs += [vsteam_lib.BuildDefinition]::new($item, $ProjectName)
            }

            Write-Output $objs
         }
      }
   }
}