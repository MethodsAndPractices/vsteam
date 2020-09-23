function Get-VSTeamUserEntitlement {
   [CmdletBinding(DefaultParameterSetName = 'List',
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamUserEntitlement')]
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

      $commonArgs = @{
         subDomain = 'vsaex'
         resource  = 'userentitlements'
         version   = $(_getApiVersion MemberEntitlementManagement)
      }

      if ($Id) {
         foreach ($item in $Id) {
            # Build the url to return the single build
            # Call the REST API
            $resp = _callAPI @commonArgs -id $item

            Write-Output $([vsteam_lib.UserEntitlement]::new($resp))
         }
      }
      else {
         # Build the url to list the teams
         $listurl = _buildRequestURI @commonArgs

         $listurl += _appendQueryString -name "top" -value $top -retainZero
         $listurl += _appendQueryString -name "skip" -value $skip -retainZero
         $listurl += _appendQueryString -name "select" -value ($select -join ",")

         # Call the REST API
         $resp = _callAPI -url $listurl

         $objs = @()

         foreach ($item in $resp.members) {
            $objs += [vsteam_lib.UserEntitlement]::new($item)
         }

         Write-Output $objs
      }
   }
}