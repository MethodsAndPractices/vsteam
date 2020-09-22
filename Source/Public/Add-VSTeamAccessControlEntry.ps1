# Add or update ACEs in the ACL for the provided token. The request body
# contains the target token, a list of ACEs and a optional merge parameter.
# In the case of a collision (by identity descriptor) with an existing ACE
# in the ACL, the "merge" parameter determines the behavior. If set, the
# existing ACE has its allow and deny merged with the incoming ACE's allow
# and deny. If unset, the existing ACE is displaced.
#
# Get-VSTeamOption 'Security' 'AccessControlEntries'
# id              : ac08c8ff-4323-4b08-af90-bcd018d380ce
# area            : Security
# resourceName    : AccessControlEntries
# routeTemplate   : _apis/{resource}/{securityNamespaceId}
# https://bit.ly/Add-VSTeamAccessControlEntry

function Add-VSTeamAccessControlEntry {
   [CmdletBinding(DefaultParameterSetName = 'ByNamespace',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamAccessControlEntry')]
   param(
      [Parameter(ParameterSetName = 'ByNamespace', Mandatory = $true, ValueFromPipeline = $true)]
      [vsteam_lib.SecurityNamespace] $SecurityNamespace,

      [Parameter(ParameterSetName = 'ByNamespaceId', Mandatory = $true)]
      [guid] $SecurityNamespaceId,

      [Parameter(Mandatory = $true)]
      [string] $Token,

      [Parameter(Mandatory = $true)]
      [string] $Descriptor,

      [Parameter(Mandatory = $true)]
      [ValidateRange(0, [int]::MaxValue)]
      [int] $AllowMask,

      [Parameter(Mandatory = $true)]
      [ValidateRange(0, [int]::MaxValue)]
      [int] $DenyMask
   )
   process {
      if ($SecurityNamespace) {
         $SecurityNamespaceId = $SecurityNamespace.ID
      }

      $body =
      @"
   {
      "token": "$Token",
      "merge": true,
      "accessControlEntries": [
         {
            "descriptor": "$Descriptor",
            "allow": $AllowMask,
            "deny": $DenyMask,
            "extendedinfo": {}
         }
      ]
   }
"@
      $resp = _callAPI -Method POST -NoProject `
         -Resource "accesscontrolentries" `
         -Id $SecurityNamespaceId `
         -Body $body `
         -Version $(_getApiVersion Core)

      if ($resp.count -ne 1) {
         throw "Expected 1 result, but got $($rep.count)"
      }

      # Storing the object before you return it cleaned up the pipeline.
      # When I just write the object from the constructor each property
      # seemed to be written
      $acl = [vsteam_lib.AccessControlEntry]::new($resp.value[0])

      Write-Output $acl
   }
}