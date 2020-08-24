function Get-VSTeamBuildDefinition {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [string] $Filter,

      [ValidateSet('build', 'xaml', 'All')]
      [Parameter(ParameterSetName = 'List')]
      [string] $Type = 'All',

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

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   
   process {
      # The REST API ignores Top and Skip but allows them to be specified & the function does the same. 
      if ($PSBoundParameters['Type'] -gt 0) {
         Write-Warning "You specified -Type $type. This parameters is ignored and will be removed in future"
      }

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
            -QueryString @{type = $type; name = $filter; includeAllProperties = $true }

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