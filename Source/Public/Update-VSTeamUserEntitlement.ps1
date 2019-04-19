function Update-VSTeamUserEntitlement
{
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High", DefaultParameterSetName = 'ByEmail')]
   param (
      [Parameter(ParameterSetName = 'ById', Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
      [Alias('UserId')]
      [string]$Id,

      [Parameter(ParameterSetName = 'ByEmail', Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
      [Alias('UserEmail')]
      [string]$Email,

      [Parameter(Mandatory = $true)]
      [ValidateSet('Advanced', 'EarlyAdopter', 'Express', 'None', 'Professional', 'StakeHolder')]
      [string]$License,

      [switch]$Force
   )

   process {
      # This will throw if this account does not support MemberEntitlementManagement
      _supportsMemberEntitlementManagement

      if ($email)
      {
         # We have to go find the id
         $user = Get-VSTeamUserEntitlement -Top 10000 | Where-Object email -eq $email

         if (-not$user)
         {
            throw "Could not find user with an email equal to $email"
         }

         $id = $user.id
      }
      else
      {
         $user = Get-VSTeamUserEntitlement -Id $id
      }

      $licenseOld = $user.accessLevel.accountLicenseType

      $obj = @{
         from = ""
         op = "replace"
         path = "/accessLevel"
         value = @{
            accountLicenseType = $License
            licensingSource = "account"
         }
      }

      $body = ConvertTo-Json -InputObject @($obj)

      if ($Force -or $PSCmdlet.ShouldProcess("$( $user.userName ) ($( $user.email ))", "Update user"))
      {
         # Call the REST API
         _callAPI -Method Patch -Body $body -SubDomain 'vsaex' -Resource 'userentitlements' -Id $id -Version $([VSTeamVersions]::MemberEntitlementManagement) -ContentType 'application/json-patch+json' | Out-Null

         Write-Output "Updated user license for $( $user.userName ) ($( $user.email )) from ($licenseOld) to ($License)"
      }
   }
}