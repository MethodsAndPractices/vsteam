function Get-VSTeamWorkItemRelationType {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamWorkItemRelationType')]
   param (
      [ValidateSet('All', 'ResourceLink', 'WorkItemLink')]
      [string]$Usage = 'WorkItemLink'
   )

   process {
      $commonArgs = @{
         area        = 'wit'
         resource    = 'workitemrelationtypes'
         version     = $(_getApiVersion Core)
         noProject   = $true
      }
      $resp = _callAPI @commonArgs

      foreach ($item in $resp.value) {
         if ($Usage -eq 'All' -or $Usage -eq $item.attributes.usage) {
            _applyTypesToWorkItemRelationType -item $item
            Write-Output $item
         }
      }
   }

}