function Add-VSTeamGitRepositoryPermission {
   [CmdletBinding(DefaultParameterSetName = 'ByProjectAndUser')]
   param(
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndDescriptor")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndGroup")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryIdAndGroup")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryIdAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryNameAndGroup")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryNameAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryIdAndDescriptor")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryNameAndDescriptor")]
      [VSTeamProject]$Project,

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
      [VSTeamGroup]$Group,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryIdAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryNameAndUser")]
      [VSTeamUser]$User,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndDescriptor")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndGroup")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryIdAndGroup")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryIdAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryNameAndGroup")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryNameAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryIdAndDescriptor")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryNameAndDescriptor")]
      [VSTeamGitRepositoryPermissions]$Allow,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndDescriptor")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndGroup")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryIdAndGroup")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryIdAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryNameAndGroup")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryNameAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryIdAndDescriptor")]
      [parameter(Mandatory = $true, ParameterSetName = "ByRepositoryNameAndDescriptor")]
      [VSTeamGitRepositoryPermissions]$Deny
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

      Add-VSTeamAccessControlEntry -SecurityNamespaceId $securityNamespaceId -Descriptor $Descriptor -Token $token -AllowMask ([int]$Allow) -DenyMask ([int]$Deny)
   }
}