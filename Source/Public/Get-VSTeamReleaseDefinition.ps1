function Get-VSTeamReleaseDefinition {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('environments', 'artifacts', 'none')]
      [string] $Expand = 'none',

      [Parameter(Mandatory = $true, ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [Parameter(Mandatory = $true, ParameterSetName = 'ByIdRaw', ValueFromPipelineByPropertyName = $true)]
      [Parameter(Mandatory = $true, ParameterSetName = 'ByIdJson', ValueFromPipelineByPropertyName = $true)]
      [Alias('ReleaseDefinitionID')]
      [int[]] $Id,

      [Parameter(Mandatory = $true, ParameterSetName = 'ByIdJson')]
      [switch]$JSON,

      [Parameter(Mandatory = $true, ParameterSetName = 'ByIdRaw')]
      [switch]$raw,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
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
                  $item = [VSTeamReleaseDefinition]::new($resp, $ProjectName)

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
         
         $objs = @()
         
         foreach ($item in $resp.value) {
            $objs += [VSTeamReleaseDefinition]::new($item, $ProjectName)
         }
         
         Write-Output $objs
      }
   }
}
