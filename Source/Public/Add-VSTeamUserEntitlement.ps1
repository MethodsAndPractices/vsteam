function Add-VSTeamUserEntitlement {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [Alias('UserEmail')]
      [string]$Email,

      [ValidateSet('Advanced', 'EarlyAdopter', 'Express', 'None', 'Professional', 'StakeHolder')]
      [string]$License = 'EarlyAdopter',

      [ValidateSet('Custom', 'ProjectAdministrator', 'ProjectContributor', 'ProjectReader', 'ProjectStakeholder')]
      [string]$Group = 'ProjectContributor',

      [ValidateSet('account', 'auto', 'msdn', 'none', 'profile', 'trial')]
      [string]$LicensingSource = "account",

      [ValidateSet('eligible', 'enterprise', 'none', 'platforms', 'premium', 'professional', 'testProfessional', 'ultimate')]
      [string]$MSDNLicenseType = "none",

      [Parameter( Position = 0 )]
      [ValidateProjectAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      $ProjectName
    )
   process {
      # This will throw if this account does not support MemberEntitlementManagement
      _hasAccount
      if (-not [VSTeamVersions]::MemberEntitlementManagement) {
            throw 'This account does not support Member Entitlement.'
      }
      $obj = @{
         accessLevel         = @{
            accountLicenseType = $License
            licensingSource    = $LicensingSource
            msdnLicenseType    = $MSDNLicenseType
         }
         user                = @{
            principalName = $email
            subjectKind   = 'user'
         }
         projectEntitlements = @{
            group      = @{
               groupType = $Group
            }
            projectRef = @{
               id = $ProjectName
            }
         }
      }

      $body = $obj | ConvertTo-Json

      # Call the REST API
      _callAPI  -Method Post -Body $body -SubDomain 'vsaex' -Resource 'userentitlements' -Version $([VSTeamVersions]::MemberEntitlementManagement) -ContentType "application/json"
   }
}
