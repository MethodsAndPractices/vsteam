function Get-VSTeamUserEntitlement {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param (
      [Parameter(ParameterSetName = 'List')]
      [int] $Top = 100,

      [Parameter(ParameterSetName = 'List')]
      [int] $Skip = 0,

      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('Projects', 'Extensions', 'Grouprules')]
      [string[]] $Select,

      [Parameter(ParameterSetName = 'ByID')]
      [Alias('UserId')]
      [string[]] $Id
   )

   process {
      # This will throw if this account does not support MemberEntitlementManagement
      _supportsMemberEntitlementManagement

      if ($Id) {
         foreach ($item in $Id) {
            # Build the url to return the single build
            # Call the REST API
            $resp = _callAPI -SubDomain 'vsaex' -Version $(_getApiVersion MemberEntitlementManagement) -Resource 'userentitlements' -id $item

            _applyTypesToUser -item $resp

            Write-Output $resp
         }
      }
      else {
         # Build the url to list the teams
         # $listurl = _buildUserURL
         $listurl = _buildRequestURI -SubDomain 'vsaex' -Resource 'userentitlements' `
            -Version $(_getApiVersion MemberEntitlementManagement)

         $listurl += _appendQueryString -name "top" -value $top -retainZero
         $listurl += _appendQueryString -name "skip" -value $skip -retainZero
         $listurl += _appendQueryString -name "select" -value ($select -join ",")

         # Call the REST API
         $resp = _callAPI -url $listurl

         # Apply a Type Name so we can use custom format view and custom type extensions
         foreach ($item in $resp.members) {
            _applyTypesToUser -item $item
         }

         Write-Output $resp.members
      }
   }
}