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

function Add-VSTeamWorkItemIterationPermission {
   [CmdletBinding(DefaultParameterSetName = 'ByProjectAndIterationIdAndUser',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamWorkItemIterationPermission')]
   param(
      [parameter(Mandatory = $true)]
      [vsteam_lib.Project]$Project,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndIterationIdAndDescriptor")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndIterationIdAndGroup")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndIterationIdAndUser")]
      [int]$IterationID,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndIterationPathAndDescriptor")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndIterationPathAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndIterationPathAndGroup")]
      [string]$IterationPath,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndIterationIdAndDescriptor")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndIterationPathAndDescriptor")]
      [string]$Descriptor,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndIterationIdAndGroup")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndIterationPathAndGroup")]
      [vsteam_lib.Group]$Group,

      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndIterationPathAndUser")]
      [parameter(Mandatory = $true, ParameterSetName = "ByProjectAndIterationIdAndUser")]
      [vsteam_lib.User]$User,

      [parameter(Mandatory = $true)]
      [vsteam_lib.WorkItemIterationPermissions]$Allow,

      [parameter(Mandatory = $true)]
      [vsteam_lib.WorkItemIterationPermissions]$Deny
   )

   process {
      # SecurityID: bf7bfa03-b2b7-47db-8113-fa2e002cc5b1
      # Token: vstfs:///Classification/Node/862eb45f-3873-41d7-89c8-4b2f8802eaa9 (https://dev.azure.com/<organization>/<project>/_apis/wit/classificationNodes/Iterations)
      # "token": "vstfs:///Classification/Node/ae76de05-8b53-4e02-9205-e73e2012585e:vstfs:///Classification/Node/f8c5b667-91dd-4fe7-bf23-3138c439d07e",

      $securityNamespaceId = "bf7bfa03-b2b7-47db-8113-fa2e002cc5b1"

      if ($IterationID) {
         $iteration = Get-VSTeamClassificationNode -ProjectName $Project.Name -Depth 0 -Id $IterationID
      }

      if ($IterationPath) {
         $iteration = Get-VSTeamClassificationNode -ProjectName $Project.Name -Depth 0 -Path $IterationPath -StructureGroup "iterations"
      }

      if (-not $iteration) {
         throw "Iteration not found"
      }

      if ($iteration.StructureType -ne "iteration") {
         throw "This is not an Iteration"
      }

      $nodes = @()
      $nodes += $iteration

      while ($iteration.ParentUrl) {
         $path = $iteration.ParentUrl -ireplace ".*(classificationNodes/Iterations)\/?"
         if ($path.length -gt 0) {
            # We have a Path to resolve
            $iteration = Get-VSTeamClassificationNode -ProjectName $Project.Name -Depth 0 -Path $path -StructureGroup "Iterations"
         }
         else {
            # We need to get the "root" node now
            $iteration = Get-VSTeamClassificationNode -ProjectName $Project.Name -Depth 0 -StructureGroup "Iterations"
         }

         $nodes += $iteration
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