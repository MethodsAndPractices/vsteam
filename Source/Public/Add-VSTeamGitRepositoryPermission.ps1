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

function Add-VSTeamGitRepositoryPermission {
   [CmdletBinding(DefaultParameterSetName = 'ByProjectAndUser',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamGitRepositoryPermission')]
   param(
      [parameter(Mandatory = $true)]
      [vsteam_lib.Project]$Project,

      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryIdAndGroup")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryIdAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryIdAndDescriptor")]
      [guid]$RepositoryId,

      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryNameAndGroup")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryNameAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryNameAndDescriptor")]
      [string]$RepositoryName,

      [parameter(Mandatory = $false, ParameterSetName = "ByRepositoryIdAndGroup")]
      [parameter(Mandatory = $false, ParameterSetName = "ByRepositoryIdAndUser")]
      [parameter(Mandatory = $false, ParameterSetName = "ByRepositoryNameAndGroup")]
      [parameter(Mandatory = $false, ParameterSetName = "ByRepositoryNameAndUser")]
      [parameter(Mandatory = $false, ParameterSetName = "ByRepositoryIdAndDescriptor")]
      [parameter(Mandatory = $false, ParameterSetName = "ByRepositoryNameAndDescriptor")]
      [string]$BranchName,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndDescriptor")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryIdAndDescriptor")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryNameAndDescriptor")]
      [string]$Descriptor,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndGroup")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryIdAndGroup")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryNameAndGroup")]
      [vsteam_lib.Group]$Group,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryIdAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryNameAndUser")]
      [vsteam_lib.User]$User,

      [parameter(Mandatory = $true)]
      [vsteam_lib.GitRepositoryPermissions]$Allow,

      [parameter(Mandatory = $true)]
      [vsteam_lib.GitRepositoryPermissions]$Deny
   )

   process {
      # SecurityNamespaceID: 2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87
      # Token: repoV2/<projectId>" <-- Whole project
      # Token: repoV2/<projectId>/<repositoryId>"  <-- Whole repository
      # Token: repoV2/<projectId>/<repositoryId>/refs/heads/<branchName>" <-- Single branch

      $securityNamespaceId = "2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87"

      # Resolve Repository Name to ID
      if ($RepositoryName) {
         $repo = Get-VSTeamGitRepository -ProjectName $Project.Name -Name $RepositoryName
         if (!$repo) {
            throw "Repository not found"
         }

         $RepositoryId = $repo.ID
      }

      # Resolve Group to Descriptor
      if ($Group) {
         $Descriptor = _getDescriptorForACL -Group $Group
      }

      # Resolve User to Descriptor
      if ($User) {
         $Descriptor = _getDescriptorForACL -User $User
      }

      $token = "repoV2/$($Project.ID)"

      if ($RepositoryId) {
         $token += "/$($RepositoryId)"
      }

      if ($BranchName) {
         $branchHex = _convertToHex($BranchName)
         $token += "/refs/heads/$($branchHex)"
      }

      Add-VSTeamAccessControlEntry -SecurityNamespaceId $securityNamespaceId `
         -Descriptor $Descriptor `
         -Token $token `
         -AllowMask ([int]$Allow) `
         -DenyMask ([int]$Deny)
   }
}