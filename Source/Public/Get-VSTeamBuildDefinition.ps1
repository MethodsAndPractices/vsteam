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
      [Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'ByIdJson')]
      [Parameter(Position = 0, ParameterSetName = 'ByID', Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [int[]] $Id,

      [Parameter(ParameterSetName = 'ByID')]
      [Parameter(ParameterSetName = 'ByIdRaw')]
      [Parameter(ParameterSetName = 'ByIdJson')]
      [int] $Revision,

      [Parameter(Mandatory = $true, ParameterSetName = 'ByIdJson')]
      [switch] $JSON,

      [Parameter(Mandatory = $true, ParameterSetName = 'ByIdRaw')]
      [switch] $raw,

      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [string] $ProjectName
   )
   
   process {
       # The REST API ignores Top and Skip but allows them to be specified & the function does the same. 
       if ($PSBoundParameters['Type'] -gt 0) {
         Write-Warning "You specified -Type $type. This parameters is ignored and will be removed in future"
      }

      if ($id) {
         foreach ($item in $id) {
            $resp = _callAPI -ProjectName $ProjectName -Id $item -Area build -Resource definitions -Version $(_getApiVersion Build) `
               -QueryString @{revision = $revision }

            if ($JSON.IsPresent) {
               $resp | ConvertTo-Json -Depth 99
            }
            else {
               if (-not $raw.IsPresent) {
                  $item = [VSTeamBuildDefinition]::new($resp, $ProjectName)
                  
                  Write-Output $item
               }
               else {
                  Write-Output $resp
               }
            }
         }
      }
      else {
         $resp = _callAPI -ProjectName $ProjectName -Area build -Resource definitions -Version $(_getApiVersion Build) `
            -QueryString @{type = $type; name = $filter; includeAllProperties = $true }

         $objs = @()

         foreach ($item in $resp.value) {
            $objs += [VSTeamBuildDefinition]::new($item, $ProjectName)
         }

         Write-Output $objs
      }
   }
}