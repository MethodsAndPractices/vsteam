
function _callMembershipAPI {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [string] $Id,
      [ValidateSet('Get', 'Post', 'Patch', 'Delete', 'Options', 'Put', 'Default', 'Head', 'Merge', 'Trace')]
      [string] $Method,
      [ValidateSet('', 'Up', 'Down')]
      [string] $Direction
   )
   # This will throw if this account does not support the graph API
   _supportsGraph

   Write-Verbose "Getting members for $Id"

   $query = @{}
   if ($Direction) {
      $query['direction'] = $Direction
   }

   # Call the REST API
   $resp = _callAPI -Area 'graph' -Resource 'memberships' `
      -Id $Id `
      -SubDomain "vssps" `
      -Method $Method `
      -Version $(_getApiVersion Graph) `
      -QueryString $query

   return $resp
}