function Add-VSTeamProjectPermission {
   [CmdletBinding(DefaultParameterSetName = 'ByProjectAndUser')]
   param(
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndDescriptor")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndGroup")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndUser")]
      [VSTeamProject]$Project,

      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndDescriptor")]
      [string]$Descriptor,

      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndGroup")]
      [vsteam_lib.Group]$Group,

      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndUser")]
      [vsteam_lib.User2]$User,

      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndDescriptor")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndGroup")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndUser")]
      [VSTeamProjectPermissions]$Allow,

      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndDescriptor")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndGroup")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndUser")]
      [VSTeamProjectPermissions]$Deny
   )

   process {
      # SecurityNamespaceID: 52d39943-cb85-4d7f-8fa8-c6baac873819
      # Token: $PROJECT:vstfs:///Classification/TeamProject/<projectId>

      $securityNamespaceId = "52d39943-cb85-4d7f-8fa8-c6baac873819"

      # Resolve Group to Descriptor
      if ($Group)
      {
         $Descriptor = _getDescriptorForACL -Group $Group
      }

      # Resolve User to Descriptor
      if ($User)
      {
         $Descriptor = _getDescriptorForACL -User $User
      }

      $token = "`$PROJECT:vstfs:///Classification/TeamProject/$($Project.ID)"
      
      Add-VSTeamAccessControlEntry -SecurityNamespaceId $securityNamespaceId -Descriptor $Descriptor -Token $token -AllowMask ([int]$Allow) -DenyMask ([int]$Deny)
   }
}