# Add a user, assign license and extensions and make them a member of a
# project group in an account.
#
# Get-VSTeamOption 'MemberEntitlementManagement' 'UserEntitlements' -subDomain 'vsaex'
# id              : 387f832c-dbf2-4643-88e9-c1aa94dbb737
# area            : MemberEntitlementManagement
# resourceName    : UserEntitlements
# routeTemplate   : _apis/{resource}/{userDescriptor}
# http://bit.ly/Add-VSTeamUserEntitlement

function Add-VSTeamUserEntitlement {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamUserEntitlement')]
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

      [Parameter(ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      # Thi swill throw if this account does not support MemberEntitlementManagement
      _supportsMemberEntitlementManagement

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
      _callAPI -Method POST -SubDomain "vsaex" `
         -Resource "userentitlements" `
         -Body $body `
         -Version $(_getApiVersion MemberEntitlementManagement)
   }
}