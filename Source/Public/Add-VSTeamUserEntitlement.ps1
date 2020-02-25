function Add-VSTeamUserEntitlement {
   [CmdletBinding()]
   param(
       [Parameter(Mandatory = $true)]
       [Alias('UserEmail')]
       [string]$Email,
       [ValidateSet('Advanced', 'EarlyAdopter', 'Express', 'None', 'Professional', 'StakeHolder')]
       [string]$License = 'EarlyAdopter',
       [ValidateSet('Custom', 'ProjectAdministrator', 'ProjectContributor', 'ProjectReader', 'ProjectStakeholder')]
       [string]$Group = 'ProjectContributor'
   )

   DynamicParam {
       _buildProjectNameDynamicParam -Mandatory $false
   }

   process {
       # Thi swill throw if this account does not support MemberEntitlementManagement
       _supportsMemberEntitlementManagement

       # Bind the parameter to a friendly variable
       $ProjectName = $PSBoundParameters["ProjectName"]

       $obj = @{
           accessLevel         = @{
               accountLicenseType = $License
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
       _callAPI  -Method Post -Body $body -SubDomain 'vsaex' -Resource 'userentitlements' -Version $([VSTeamVersions]::MemberEntitlementManagement) -ContentType "application/json;charset=utf-8"
   }
}