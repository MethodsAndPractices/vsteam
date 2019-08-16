function Add-VSTeamWorkItemAreaPermission {
   [CmdletBinding(DefaultParameterSetName = 'ByProjectAndAreaIdAndUser')]
   param(
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaIdAndDescriptor")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaIdAndGroup")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaIdAndUser")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaPathAndDescriptor")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaPathAndUser")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaPathAndGroup")]
      [VSTeamProject]$Project,

      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaIdAndDescriptor")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaIdAndGroup")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaIdAndUser")]
      [int]$AreaID,

      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaPathAndDescriptor")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaPathAndUser")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaPathAndGroup")]
      [string]$AreaPath,

      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaIdAndDescriptor")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaPathAndDescriptor")]
      [string]$Descriptor,

      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaIdAndGroup")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaPathAndGroup")]
      [VSTeamGroup]$Group,

      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaPathAndUser")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaIdAndUser")]
      [VSTeamUser]$User,

      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaIdAndDescriptor")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaIdAndGroup")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaIdAndUser")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaPathAndDescriptor")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaPathAndUser")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaPathAndGroup")]
      [VSTeamWorkItemAreaPermissions]$Allow,

      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaIdAndDescriptor")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaIdAndGroup")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaIdAndUser")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaPathAndDescriptor")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaPathAndUser")]
      [parameter(Mandatory=$true,ParameterSetName="ByProjectAndAreaPathAndGroup")]
      [VSTeamWorkItemAreaPermissions]$Deny
   )

   process {
      # SecurityID: 83e28ad4-2d72-4ceb-97b0-c7726d5502c3
      # Token: vstfs:///Classification/Node/862eb45f-3873-41d7-89c8-4b2f8802eaa9 (https://dev.azure.com/<organization>/<project>/_apis/wit/classificationNodes/Areas)
      # "token": "vstfs:///Classification/Node/ae76de05-8b53-4e02-9205-e73e2012585e:vstfs:///Classification/Node/f8c5b667-91dd-4fe7-bf23-3138c439d07e",

      $securityNamespaceId = "83e28ad4-2d72-4ceb-97b0-c7726d5502c3"

      if ($AreaID)
      {
         $area = Get-VSTeamClassificationNode -ProjectName $Project.Name -Depth 0 -Ids $AreaID
      }

      if ($AreaPath)
      {
         $area = Get-VSTeamClassificationNode -ProjectName $Project.Name -Depth 0 -Path $AreaPath -StructureGroup "areas"
      }

      if (-not $area)
      {
         throw "Area not found"
      }

      if ($area.StructureType -ne "area")
      {
         throw "This is not an Area"
      }

      $nodes = @()
      $nodes += $area

      while ($area.ParentUrl)
      {
         $path = $area.ParentUrl -ireplace ".*(classificationNodes/Areas)\/?"
         if ($path.length -gt 0)
         {
            # We have a Path to resolve
            $area = Get-VSTeamClassificationNode -ProjectName $Project.Name -Depth 0 -Path $path -StructureGroup "Areas"
         } else {
            # We need to get the "root" node now
            $area = Get-VSTeamClassificationNode -ProjectName $Project.Name -Depth 0 -StructureGroup "Areas"
         }
   
         $nodes += $area
      }

      # Build Token from Path
      [array]::Reverse($nodes)
      $token = ($nodes | ForEach-Object { "vstfs:///Classification/Node/$($_.Identifier)" })  -join ":"

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

      Add-VSTeamAccessControlEntry -SecurityNamespaceId $securityNamespaceId -Descriptor $Descriptor -Token $token -AllowMask ([int]$Allow) -DenyMask ([int]$Deny)
   }
}