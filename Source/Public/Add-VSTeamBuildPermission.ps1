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

function Add-VSTeamBuildPermission {
   [CmdletBinding(DefaultParameterSetName = 'ByProjectAndUser',
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamBuildPermission')]
   param(
      [parameter(Mandatory = $true)]
      [string]$ProjectID,

      [parameter(Mandatory = $false)]
      [string]$BuildID,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndDescriptor")]
      [string]$Descriptor,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndGroup")]
      [object]$Group,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndUser")]
      [object]$User,

      [parameter(Mandatory = $false)]
      [vsteam_lib.BuildPermissions]$Allow,

      [parameter(Mandatory = $false)]
      [vsteam_lib.BuildPermissions]$Deny,

      [Parameter(Mandatory = $false)]
      [switch] $OverwriteMask
   )

   process {
      # SecurityNamespaceID: 33344d9c-fc72-4d6f-aba5-fa317101a7e9
      # Token: <projectId>/<pipelineId>

      $securityNamespaceId = "33344d9c-fc72-4d6f-aba5-fa317101a7e9"

      # Resolve Group to Descriptor
      if ($Group) {
         $Descriptor = _getDescriptorForACL -Group $Group
      }

      # Resolve User to Descriptor
      if ($User) {
         $Descriptor = _getDescriptorForACL -User $User
      }

      $token = $null
      if ($BuildID) {
         $token = "$ProjectID/$($BuildID)"
      }
      else {
         $token = "$ProjectID"
      }

      Add-VSTeamAccessControlEntry -SecurityNamespaceId $securityNamespaceId `
         -Descriptor $Descriptor `
         -Token $token `
         -AllowMask ([int]$Allow) `
         -DenyMask ([int]$Deny) `
         -OverwriteMask $OverwriteMask
   }
}
