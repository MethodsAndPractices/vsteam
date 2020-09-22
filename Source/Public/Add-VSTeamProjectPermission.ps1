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

function Add-VSTeamProjectPermission {
   [CmdletBinding(DefaultParameterSetName = 'ByProjectAndUser',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamProjectPermission')]
   param(
      [parameter(Mandatory = $true)]
      [vsteam_lib.Project]$Project,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndDescriptor")]
      [string]$Descriptor,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndGroup")]
      [vsteam_lib.Group]$Group,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndUser")]
      [vsteam_lib.User]$User,

      [parameter(Mandatory = $true)]
      [vsteam_lib.ProjectPermissions]$Allow,

      [parameter(Mandatory = $true)]
      [vsteam_lib.ProjectPermissions]$Deny
   )

   process {
      # SecurityNamespaceID: 52d39943-cb85-4d7f-8fa8-c6baac873819
      # Token: $PROJECT:vstfs:///Classification/TeamProject/<projectId>

      $securityNamespaceId = "52d39943-cb85-4d7f-8fa8-c6baac873819"

      # Resolve Group to Descriptor
      if ($Group) {
         $Descriptor = _getDescriptorForACL -Group $Group
      }

      # Resolve User to Descriptor
      if ($User) {
         $Descriptor = _getDescriptorForACL -User $User
      }

      $token = "`$PROJECT:vstfs:///Classification/TeamProject/$($Project.ID)"

      Add-VSTeamAccessControlEntry -SecurityNamespaceId $securityNamespaceId `
         -Descriptor $Descriptor `
         -Token $token `
         -AllowMask ([int]$Allow) `
         -DenyMask ([int]$Deny)
   }
}