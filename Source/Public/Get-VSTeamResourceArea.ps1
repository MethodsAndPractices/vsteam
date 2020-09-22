function Get-VSTeamResourceArea {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamResourceArea')]
   param()

   # Call the REST API
   $resp = _callAPI -Resource 'resourceareas'

   # Apply a Type Name so we can use custom format view and custom type extensions
   foreach ($item in $resp.value) {
      _applyTypes -item $item -type 'vsteam_lib.ResourceArea'
   }

   Write-Output $resp.value
}