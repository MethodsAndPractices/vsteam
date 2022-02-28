function Get-VSTeamUserEntitlement {
   [CmdletBinding(DefaultParameterSetName = 'List',
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamUserEntitlement')]
   param (
      [Parameter(ParameterSetName = 'List')]
      [int] $Top = 100,

      [Parameter(ParameterSetName = 'List')]
      [int] $Skip = 0,

      [Parameter(ParameterSetName = 'List')]
      [Parameter(ParameterSetName = 'PagedFilter')]
      [Parameter(ParameterSetName = 'PagedParams')]
      [ValidateSet('Projects', 'Extensions', 'Grouprules')]
      [string[]] $Select,

      [Parameter(ParameterSetName = 'ByID')]
      [Alias('UserId')]
      [string[]] $Id,

      [Parameter(ParameterSetName = 'PagedFilter')]
      [Parameter(ParameterSetName = 'PagedParams')]
      [int] $MaxPages = 0,

      [Parameter(ParameterSetName = 'PagedFilter')]
      [string] $Filter,

      [Parameter(ParameterSetName = 'PagedParams')]
      [ValidateSet('Account-Stakeholder', 'Account-Express', 'Account-Advanced', IgnoreCase = $false)]
      [Alias('License')]
      [string] $LicenseId,                                                            #license name is case sensitive

      [Parameter(ParameterSetName = 'PagedParams')]
      [ValidateSet('guest', 'member', IgnoreCase = $false)]                            #userType is case sensitive: values in lowercase
      [string] $UserType,

      [Parameter(ParameterSetName = 'PagedParams')]
      [Alias('UserName')]
      [Alias('Mail')]
      [string] $Name
   )


   process {
      # This will throw if this account does not support MemberEntitlementManagement 
      # or supported version is not correct with the type of API call
      $paramCounter = _countParameters -BoundParameters $PSBoundParameters
      $paramset = 'PagedParams', 'PagedFilter'
      if ($paramCounter -eq 0) {
         $memberEntitlementManagementRequirement = $null
      } elseif ($paramset -contains $PSCmdlet.ParameterSetName) {
         $memberEntitlementManagementRequirement = "-ge '6.0'"
      } else {
         $memberEntitlementManagementRequirement = "-le '5.1'"
      }
      _supportsMemberEntitlementManagement $memberEntitlementManagementRequirement


      $apiVersion = _getApiVersion MemberEntitlementManagement
      $commonArgs = @{
         subDomain = 'vsaex'
         resource  = 'userentitlements'
         version   = $apiVersion
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
         # use the appropiate syntax depending on the API version
         $useContinuationToken = $false
         if ($paramCounter -eq 0) {
            if ($apiVersion -gt '6.0') {
               $useContinuationToken = $true
            }
         } else {
            if ($paramset -contains $PSCmdlet.ParameterSetName) {
               $useContinuationToken = $true
            }
         }

         $listurl = _buildRequestURI @commonArgs
         $objs = @()
         Write-Verbose "Use continuation token: $useContinuationToken"
         if ($useContinuationToken) {
            if ($psCmdLet.ParameterSetName -eq 'PagedParams') {
               #parameter names must be lowercase, parameter values depends on the parameter
               if ($name) {
                  $filter += "name eq '$name' and "
               }
               if ($LicenseId) {

                  $filter += "licenseId eq '$LicenseId' and " 
               }
               if ($UserType) {
                  $filter += "userType eq '$UserType' and "
               }
               $filter = $filter.SubString(0, $filter.Length - 5)
            }
            $listurl += _appendQueryString -name "`$filter" -value $filter
            $listurl += _appendQueryString -name "select" -value ($select -join ",")

            # Call the REST API
            if ($MaxPages -le 0){
               $MaxPages = [int32]::MaxValue
            }
            $i = 0
            $apiParameters = $listurl
            Write-Verbose "API params: $listurl"
            do {
               $resp = _callAPI -url $apiParameters
               $continuationToken = $resp.continuationToken
               $i++
               Write-Verbose "page $i"
               foreach ($item in $resp.members) {
                  $objs += [vsteam_lib.UserEntitlement]::new($item)
               }
               if (-not [String]::IsNullOrEmpty($continuationToken)) {
                  $continuationToken = [uri]::EscapeDataString($continuationToken)
                  $apiParameters = "${listurl}&continuationToken=$continuationToken"
               }
            } while (-not [String]::IsNullOrEmpty($continuationToken) -and $i -lt $MaxPages)

         } else {
            $listurl += _appendQueryString -name "top" -value $top -retainZero
            $listurl += _appendQueryString -name "skip" -value $skip -retainZero
            $listurl += _appendQueryString -name "select" -value ($select -join ",")

            # Call the REST API
            Write-Verbose "API params: $listurl"
            $resp = _callAPI -url $listurl

            foreach ($item in $resp.members) {
               $objs += [vsteam_lib.UserEntitlement]::new($item)
            }
         }
         Write-Output $objs

      }
   }
}


function _countParameters() {
   param(
      $BoundParameters
   )
   $counter = 0
   $advancedPameters = @('Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction', 'ErrorVariable', 'WarningVariable', 'InformationVariable', 'OutVariable', 'OutBuffer', 'PipelineVariable')
   foreach($p in $BoundParameters.GetEnumerator()) {
      if ($p.Key -notin $advancedPameters) {
         $counter++
      }
   }
   Write-Verbose "Found $counter parameters"
   $counter
}
