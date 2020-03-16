Set-StrictMode -Version Latest

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

$accessControlListResult = Get-Content "$PSScriptRoot\sampleFiles\accessControlListResult.json" -Raw | ConvertFrom-Json
$securityNamespace = Get-Content "$PSScriptRoot\sampleFiles\securityNamespace.json" -Raw | ConvertFrom-Json

$securityNamespaceObject = [VSTeamSecurityNamespace]::new($securityNamespace.value)

Describe 'Get-VSTeamAccessControlList' {
   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

   # You have to set the version or the api-version will not be added when
   # [VSTeamVersions]::Core = ''
   [VSTeamVersions]::Core = '5.0'

   Context 'by SecurityNamespaceId' {
      Mock Invoke-RestMethod {
         # If this test fails uncomment the line below to see how the mock was called.
         # Write-Host $args

         return $accessControlListResult
      } -Verifiable

      # Even with a default set this URI should not have the project added.
      Set-VSTeamDefaultProject -Project Testing

      Get-VSTeamAccessControlList -SecurityNamespaceId 5a27515b-ccd7-42c9-84f1-54c998f03866 -Token "SomeToken" -Descriptors "SomeDescriptor" -IncludeExtendedInfo -Recurse

      It 'Should return ACLs' {
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrollists/5a27515b-ccd7-42c9-84f1-54c998f03866*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*descriptors=SomeDescriptor*" -and
            $Uri -like "*includeExtendedInfo=True*" -and
            $Uri -like "*token=SomeToken*" -and
            $Uri -like "*recurse=True*" -and
            $Method -eq "Get"
         }
      }
   }

   Context 'by SecurityNamespace' {
      Mock Invoke-RestMethod {
         # If this test fails uncomment the line below to see how the mock was called.
         # Write-Host $args

         return $accessControlListResult
      } -Verifiable

      Get-VSTeamAccessControlList -SecurityNamespace $securityNamespaceObject -Token "SomeToken" -Descriptors "SomeDescriptor"

      It 'Should return ACLs' {
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrollists/58450c49-b02d-465a-ab12-59ae512d6531*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*descriptors=SomeDescriptor*" -and
            $Uri -like "*token=SomeToken*" -and
            $Method -eq "Get"
         }
      }
   }

   Context 'by SecurityNamespace (pipeline)' {
      Mock Invoke-RestMethod { return $accessControlListResult } -Verifiable

      $securityNamespaceObject | Get-VSTeamAccessControlList -Token "SomeToken" -Descriptors "SomeDescriptor"

      It 'Should return ACEs' {
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrollists/58450c49-b02d-465a-ab12-59ae512d6531*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Uri -like "*descriptors=SomeDescriptor*" -and
            $Uri -like "*token=SomeToken*" -and
            $Method -eq "Get"
         }
      }
   }

   Context 'by securityNamespaceId throws' {
      Mock Invoke-RestMethod { throw 'Error' }

      It 'Should throw' {
         { Get-VSTeamAccessControlList -SecurityNamespaceId 5a27515b-ccd7-42c9-84f1-54c998f03866 -Token "SomeToken" -Descriptors "SomeDescriptor" -IncludeExtendedInfo -Recurse } | Should Throw
      }
   }

   Context 'by SecurityNamespace throws' {
      Mock Invoke-RestMethod { throw 'Error' }

      It 'Should throw' {
         { Get-VSTeamAccessControlList  -SecurityNamespace $securityNamespaceObject -Token "SomeToken" -Descriptors "SomeDescriptor" -IncludeExtendedInfo -Recurse } | Should Throw
      }
   }
}