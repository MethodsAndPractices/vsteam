function Get-VSTeamResourceArea {
   [CmdletBinding()]
   param()

   # Call the REST API
   $resp = _callAPI -Resource 'resourceareas'

   # Apply a Type Name so we can use custom format view and custom type extensions
   foreach ($item in $resp.value) {
      _applyTypes -item $item -type 'Team.ResourceArea'
   }

   Write-Output $resp.value
}