
function _callMembershipAPI {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [string] $Id,

      [ValidateSet('GET', 'POST', 'PATCH', 'DELETE', 'OPTIONS', 'PUT', 'DEFAULT', 'HEAD', 'MERGE', 'TRACE')]
      [string] $Method = 'GET',

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
   $resp = _callAPI -Method $Method -SubDomain vssps `
      -Area 'graph' `
      -Resource 'memberships' `
      -Id $Id `
      -QueryString $query `
      -Version $(_getApiVersion Graph)

   return $resp.value
}