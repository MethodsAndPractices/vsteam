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

function Add-VSTeamWorkItemAreaPermission {
   [CmdletBinding(DefaultParameterSetName = 'ByProjectAndAreaIdAndUser',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamWorkItemAreaPermission')]
   param(
      [parameter(Mandatory = $true)]
      [vsteam_lib.Project]$Project,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndAreaIdAndDescriptor")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndAreaIdAndGroup")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndAreaIdAndUser")]
      [int]$AreaID,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndAreaPathAndDescriptor")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndAreaPathAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndAreaPathAndGroup")]
      [string]$AreaPath,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndAreaIdAndDescriptor")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndAreaPathAndDescriptor")]
      [string]$Descriptor,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndAreaIdAndGroup")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndAreaPathAndGroup")]
      [vsteam_lib.Group]$Group,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndAreaPathAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndAreaIdAndUser")]
      [vsteam_lib.User]$User,

      [parameter(Mandatory = $true)]
      [vsteam_lib.WorkItemAreaPermissions]$Allow,

      [parameter(Mandatory = $true)]
      [vsteam_lib.WorkItemAreaPermissions]$Deny
   )

   process {
      # SecurityID: 83e28ad4-2d72-4ceb-97b0-c7726d5502c3
      # Token: vstfs:///Classification/Node/862eb45f-3873-41d7-89c8-4b2f8802eaa9 (https://dev.azure.com/<organization>/<project>/_apis/wit/classificationNodes/Areas)
      # "token": "vstfs:///Classification/Node/ae76de05-8b53-4e02-9205-e73e2012585e:vstfs:///Classification/Node/f8c5b667-91dd-4fe7-bf23-3138c439d07e",

      $securityNamespaceId = "83e28ad4-2d72-4ceb-97b0-c7726d5502c3"

      if ($AreaID) {
         $area = Get-VSTeamClassificationNode -ProjectName $Project.Name -Depth 0 -Id $AreaID
      }

      if ($AreaPath) {
         $area = Get-VSTeamClassificationNode -ProjectName $Project.Name -Depth 0 -Path $AreaPath -StructureGroup "areas"
      }

      if (-not $area) {
         throw "Area not found"
      }

      if ($area.StructureType -ne "area") {
         throw "This is not an Area"
      }

      $nodes = @()
      $nodes += $area

      while ($area.ParentUrl) {
         $path = $area.ParentUrl -ireplace ".*(classificationNodes/Areas)\/?"
         if ($path.length -gt 0) {
            # We have a Path to resolve
            $area = Get-VSTeamClassificationNode -ProjectName $Project.Name -Depth 0 -Path $path -StructureGroup "Areas"
         }
         else {
            # We need to get the "root" node now
            $area = Get-VSTeamClassificationNode -ProjectName $Project.Name -Depth 0 -StructureGroup "Areas"
         }

         $nodes += $area
      }

      # Build Token from Path
      [array]::Reverse($nodes)
      $token = ($nodes | ForEach-Object { "vstfs:///Classification/Node/$($_.Identifier)" }) -join ":"

      # Resolve Group to Descriptor
      if ($Group) {
         $Descriptor = _getDescriptorForACL -Group $Group
      }

      # Resolve User to Descriptor
      if ($User) {
         $Descriptor = _getDescriptorForACL -User $User
      }

      Add-VSTeamAccessControlEntry -SecurityNamespaceId $securityNamespaceId `
         -Descriptor $Descriptor `
         -Token $token `
         -AllowMask ([int]$Allow) `
         -DenyMask ([int]$Deny)
   }
}