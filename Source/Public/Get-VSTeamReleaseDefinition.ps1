function Get-VSTeamReleaseDefinition {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamReleaseDefinition')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('environments', 'artifacts', 'none')]
      [string] $Expand = 'none',

      [Parameter(Mandatory = $true, ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [Parameter(Mandatory = $true, ParameterSetName = 'ByIdRaw', ValueFromPipelineByPropertyName = $true)]
      [Alias('ReleaseDefinitionID')]
      [int[]] $Id,

      [switch]$JSON,

      [Parameter(Mandatory = $true, ParameterSetName = 'ByIdRaw')]
      [switch]$raw,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      $commonArgs = @{
         subDomain   = 'vsrm'
         area        = 'release'
         resource    = 'definitions'
         projectName = $ProjectName
         version     = $(_getApiVersion Release)
      }

      if ($id) {
         foreach ($item in $id) {
            $resp = _callAPI @commonArgs -id $item

            if ($JSON.IsPresent) {
               $resp | ConvertTo-Json -Depth 99
            }
            else {
               if (-not $raw.IsPresent) {
                  $item = [vsteam_lib.ReleaseDefinition]::new($resp, $ProjectName)

                  Write-Output $item
               }
               else {
                  Write-Output $resp
               }
            }
         }
      }
      else {
         $listurl = _buildRequestURI @commonArgs

         if ($expand -ne 'none') {
            $listurl += "&`$expand=$($expand)"
         }

         # Call the REST API
         $resp = _callAPI -url $listurl

         if ($JSON.IsPresent) {
            $resp | ConvertTo-Json -Depth 99
         }
         else {
            $objs = @()

            foreach ($item in $resp.value) {
               $objs += [vsteam_lib.ReleaseDefinition]::new($item, $ProjectName)
            }

            Write-Output $objs
         }
      }
   }
}
