function Update-VSTeamUserEntitlement { 
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High", DefaultParameterSetName = 'ByEmail',
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamUserEntitlement')]
   param (
      [Parameter(ParameterSetName = 'ById', Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
      [Alias('UserId')]
      [string]$Id,

      [Parameter(ParameterSetName = 'ByEmail', Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
      [Alias('UserEmail')]
      [string]$Email,

      [Parameter(ParameterSetName = 'ById', Mandatory = $false)]
      [Parameter(ParameterSetName = 'ByEmail', Mandatory = $false)]
      [ValidateSet('Advanced', 'EarlyAdopter', 'Express', 'None', 'Professional', 'StakeHolder')]
      [string]$License,

      [ValidateSet('account', 'auto', 'msdn', 'none', 'profile', 'trial')]
      [Parameter(ParameterSetName = 'ById', Mandatory = $false)]
      [Parameter(ParameterSetName = 'ByEmail')]
      [string]$LicensingSource,

      [ValidateSet('eligible', 'enterprise', 'none', 'platforms', 'premium', 'professional', 'testProfessional', 'ultimate')]
      [Parameter(ParameterSetName = 'ById', Mandatory = $false)]
      [Parameter(ParameterSetName = 'ByEmail')]
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

      $newLicenseType = if ($false -eq [string]::IsNullOrEmpty($License)) { $License } else { $licenseTypeOriginal }
      $newLicenseSource = if ($false -eq [string]::IsNullOrEmpty($LicensingSource)) { $LicensingSource } else { $licenseSourceOriginal }
      $newMSDNLicenseType = if ($false -eq [string]::IsNullOrEmpty($MSDNLicenseType)) { $MSDNLicenseType } else { $msdnLicenseTypeOriginal }

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

      $body = ConvertTo-Json -InputObject @($obj) -Depth 100 -Compress

      $msg = "$( $user.userName ) ($( $user.email ))"

      if ($Force -or $PSCmdlet.ShouldProcess($msg, "Update user")) {
         # Call the REST API
         _callAPI -Method PATCH -SubDomain vsaex -NoProject `
            -Resource userentitlements `
            -Id $id `
            -ContentType 'application/json-patch+json; charset=utf-8' `
            -Body $body `
            -Version $(_getApiVersion MemberEntitlementManagement) | Out-Null

         Write-Information "Updated user license for $( $user.userName ) ($( $user.email )) from LicenseType: ($licenseTypeOriginal) to ($newLicenseType)"
         Write-Information "Updated user license for $( $user.userName ) ($( $user.email )) from LicenseSource: ($licenseSourceOriginal) to ($newLicenseSource)"
         Write-Information "Updated user license for $( $user.userName ) ($( $user.email )) from MSDNLicenseType: ($msdnLicenseTypeOriginal) to ($newMSDNLicenseType)"
      }
   }
}
