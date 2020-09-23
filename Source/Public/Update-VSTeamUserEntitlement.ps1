function Update-VSTeamUserEntitlement {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High", DefaultParameterSetName = 'ByEmailLicenseOnly',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamUserEntitlement')]
   param (
      [Parameter(ParameterSetName = 'ByIdLicenseOnly', Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
      [Parameter(ParameterSetName = 'ByIdWithSource', Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
      [Alias('UserId')]
      [string]$Id,

      [Parameter(ParameterSetName = 'ByEmailLicenseOnly', Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
      [Parameter(ParameterSetName = 'ByEmailWithSource', Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
      [Alias('UserEmail')]
      [string]$Email,

      [Parameter(ParameterSetName = 'ByIdLicenseOnly', Mandatory = $true)]
      [Parameter(ParameterSetName = 'ByIdWithSource')]
      [Parameter(ParameterSetName = 'ByEmailLicenseOnly', Mandatory = $true)]
      [Parameter(ParameterSetName = 'ByEmailWithSource')]
      [ValidateSet('Advanced', 'EarlyAdopter', 'Express', 'None', 'Professional', 'StakeHolder')]
      [string]$License,

      [ValidateSet('account', 'auto', 'msdn', 'none', 'profile', 'trial')]
      [Parameter(ParameterSetName = 'ByIdWithSource')]
      [Parameter(ParameterSetName = 'ByEmailWithSource')]
      [string]$LicensingSource,

      [ValidateSet('eligible', 'enterprise', 'none', 'platforms', 'premium', 'professional', 'testProfessional', 'ultimate')]
      [Parameter(ParameterSetName = 'ByIdWithSource')]
      [Parameter(ParameterSetName = 'ByEmailWithSource')]
      [string]$MSDNLicenseType,

      [switch]$Force
   )

   Process {
      # This will throw if this account does not support MemberEntitlementManagement
      _supportsMemberEntitlementManagement

      if ($email) {
         # We have to go find the id
         $user = Get-VSTeamUserEntitlement -Top 10000 | Where-Object email -eq $email

         if (-not $user) {
            throw "Could not find user with an email equal to $email"
         }

         $id = $user.id
      }
      else {
         $user = Get-VSTeamUserEntitlement -Id $id
      }

      $licenseTypeOriginal = $user.accessLevel.accountLicenseType
      $licenseSourceOriginal = $user.accessLevel.licensingSource
      $msdnLicenseTypeOriginal = $user.accessLevel.msdnLicenseType

      $newLicenseType = if ($License) { $License } else { $licenseTypeOriginal }
      $newLicenseSource = if ($LicensingSource) { $LicensingSource } else { $licenseSourceOriginal }
      $newMSDNLicenseType = if ($MSDNLicenseType) { $MSDNLicenseType } else { $msdnLicenseTypeOriginal }

      $obj = @{
         from  = ""
         op    = "replace"
         path  = "/accessLevel"
         value = @{
            accountLicenseType = $newLicenseType
            licensingSource    = $newLicenseSource
            msdnLicenseType    = $newMSDNLicenseType
         }
      }

      $body = ConvertTo-Json -InputObject @($obj)

      $msg = "$( $user.userName ) ($( $user.email ))"

      if ($Force -or $PSCmdlet.ShouldProcess($msg, "Update user")) {
         # Call the REST API
         _callAPI -Method PATCH -SubDomain vsaex -NoProject `
            -Resource userentitlements `
            -Id $id `
            -ContentType 'application/json-patch+json' `
            -Body $body `
            -Version $(_getApiVersion MemberEntitlementManagement) | Out-Null

         Write-Output "Updated user license for $( $user.userName ) ($( $user.email )) from LicenseType: ($licenseTypeOriginal) to ($newLicenseType)"
         Write-Output "Updated user license for $( $user.userName ) ($( $user.email )) from LicenseSource: ($licenseSourceOriginal) to ($newLicenseSource)"
         Write-Output "Updated user license for $( $user.userName ) ($( $user.email )) from MSDNLicenseType: ($msdnLicenseTypeOriginal) to ($newMSDNLicenseType)"
      }
   }
}