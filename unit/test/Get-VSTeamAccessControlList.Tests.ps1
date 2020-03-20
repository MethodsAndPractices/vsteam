Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamSecurityNamespace.ps1"
. "$here/../../Source/Classes/VSTeamAccessControlEntry.ps1"
. "$here/../../Source/Classes/VSTeamAccessControlList.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Set-VSTeamDefaultProject.ps1"
. "$here/../../Source/Public/Get-VSTeamSecurityNamespace.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamAccessControlList' {
   ## Arrange
   # You have to set the version or the api-version will not be added when versions = ''
   [VSTeamVersions]::Core = '5.0'

   $accessControlListResult = Get-Content "$PSScriptRoot\sampleFiles\accessControlListResult.json" -Raw | ConvertFrom-Json

   $securityNamespace = Get-Content "$PSScriptRoot\sampleFiles\securityNamespace.json" -Raw | ConvertFrom-Json
   $securityNamespaceObject = [VSTeamSecurityNamespace]::new($securityNamespace.value[0])

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' }

   Context 'Get-VSTeamAccessControlList' {
      Mock Invoke-RestMethod { return $accessControlListResult }
      Mock Invoke-RestMethod { throw 'Error' } -ParameterFilter { $Uri -like "*token=boom*" }

      It 'by SecurityNamespaceId should return ACLs' {
         ## Arrange
         # Even with a default set this URI should not have the project added.
         Set-VSTeamDefaultProject -Project Testing

         ## Act
         Get-VSTeamAccessControlList -SecurityNamespaceId 5a27515b-ccd7-42c9-84f1-54c998f03866 -Token "SomeToken" -Descriptors "SomeDescriptor" -IncludeExtendedInfo -Recurse

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrollists/5a27515b-ccd7-42c9-84f1-54c998f03866*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*descriptors=SomeDescriptor*" -and
            $Uri -like "*includeExtendedInfo=True*" -and
            $Uri -like "*token=SomeToken*" -and
            $Uri -like "*recurse=True*" -and
            $Method -eq "Get"
         }
      }

      It 'by SecurityNamespace should return ACLs' {
         ## Act
         # I use $securityNamespace.value[0] here because using securityNamespaceObject was leading to issues
         Get-VSTeamAccessControlList -SecurityNamespace $($securityNamespace.value[0]) -Token "SomeToken" -Descriptors "SomeDescriptor"

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrollists/58450c49-b02d-465a-ab12-59ae512d6531*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*descriptors=SomeDescriptor*" -and
            $Uri -like "*token=SomeToken*" -and
            $Method -eq "Get"
         }
      }

      It 'by SecurityNamespace (pipeline) should return ACEs' {
         ## Act
         $securityNamespaceObject | Get-VSTeamAccessControlList -Token "AcesToken" -Descriptors "AcesDescriptor"

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrollists/58450c49-b02d-465a-ab12-59ae512d6531*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*descriptors=AcesDescriptor*" -and
            $Uri -like "*token=AcesToken*" -and
            $Method -eq "Get"
         }
      }

      It 'by SecurityNamespaceId should throw' {
         ## Act / Assert
         { Get-VSTeamAccessControlList -SecurityNamespaceId 5a27515b-ccd7-42c9-84f1-54c998f03866 -Token "boom" -Descriptors "SomeDescriptor" -IncludeExtendedInfo -Recurse } | Should Throw
      }

      It 'by SecurityNamespace should throw' {
         ## Act / Assert
         { Get-VSTeamAccessControlList  -SecurityNamespace $securityNamespaceObject -Token "boom" -Descriptors "SomeDescriptor" -IncludeExtendedInfo -Recurse } | Should Throw
      }
   }
}