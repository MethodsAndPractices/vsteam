function Remove-VSTeamUserEntitlement {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High", DefaultParameterSetName = 'ById')]
   param(
       [Parameter(ParameterSetName = 'ById', Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
       [Alias('UserId')]
       [string]$Id,

       [Parameter(ParameterSetName = 'ByEmail', Mandatory = $True, ValueFromPipelineByPropertyName = $true)]
       [Alias('UserEmail')]
       [string]$Email,

       [switch]$Force
   )

   process {
       # This will throw if this account does not support MemberEntitlementManagement
       _supportsMemberEntitlementManagement

       if ($email) {
           # We have to go find the id
           $user = Get-VSTeamUserEntitlement | Where-Object email -eq $email

           if (-not $user) {
               throw "Could not find user with an email equal to $email"
           }

           $id = $user.id

       } else {
           $user = Get-VSTeamUserEntitlement -Id $id
       }

       if ($Force -or $PSCmdlet.ShouldProcess("$($user.userName) ($($user.email))", "Delete user")) {
           # Call the REST API
           _callAPI -Method Delete -SubDomain 'vsaex' -Resource 'userentitlements' -Id $Id -Version $(_getApiVersion MemberEntitlementManagement) | Out-Null

           Write-Output "Deleted user $($user.userName) ($($user.email))"
       }
   }
}