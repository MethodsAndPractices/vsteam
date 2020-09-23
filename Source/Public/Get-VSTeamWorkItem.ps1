function Get-VSTeamWorkItem {
   [CmdletBinding(DefaultParameterSetName = 'ByID',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamWorkItem')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int[]] $Id,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('fail', 'omit')]
      [string] $ErrorPolicy = 'omit',

      [ValidateSet('None', 'Relations', 'Fields', 'Links', 'All')]
      [string] $Expand = 'None',

      [string[]] $Fields
   )

   Process {
      # Call the REST API
      $commonArgs = @{
         NoProject = $true
         Area      = 'wit'
         Resource  = 'workitems'
         Version   = $(_getApiVersion Core)
      }
      if ($Id.Length -gt 1) {
         $resp = _callAPI @commonArgs `
            -Querystring @{
            '$Expand'   = $Expand
            fields      = ($Fields -join ',')
            errorPolicy = $ErrorPolicy
            ids         = ($Id -join ',')
         }

         foreach ($item in $resp.value) {
            _applyTypesToWorkItem -item $item
         }

         return $resp.value
      }
      else {
         $a = $Id[0]
         $resp = _callAPI @commonArgs -id "$a" `
            -Querystring @{
            '$Expand' = $Expand
            fields    = ($Fields -join ',')
         }

         _applyTypesToWorkItem -item $resp

         return $resp
      }
   }
}