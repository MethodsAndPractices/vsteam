Set-StrictMode -Version Latest

Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamSecurityNamespace.ps1"
. "$here/../../Source/Classes/VSTeamAccessControlEntry.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Set-VSTeamDefaultProject.ps1"
. "$here/../../Source/Public/Get-VSTeamSecurityNamespace.ps1"
. "$here/../../Source/Public/$sut"

$securityNamespace = Get-Content "$PSScriptRoot\sampleFiles\securityNamespace.json" -Raw | ConvertFrom-Json
$accessControlEntryResult = Get-Content "$PSScriptRoot\sampleFiles\accessControlEntryResult.json" -Raw | ConvertFrom-Json

$securityNamespaceObject = [VSTeamSecurityNamespace]::new($securityNamespace.value)
  
Describe 'VSTeamAccessControlEntry' {
   # This API must be called with no project. However, if a default project is
   # set that gets added to the URI.

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }
   
   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' }
      
   # You have to set the version or the api-version will not be added when
   # [VSTeamVersions]::Core = ''
   [VSTeamVersions]::Core = '5.0'

   Context 'Add-VSTeamAccessControlEntry by SecurityNamespaceId' {
      Mock Invoke-RestMethod {
         # If this test fails uncomment the line below to see how the mock was called.
         # Write-Host $args

         return $accessControlEntryResult
      } -Verifiable

      # Even with a default set this URI should not have the project added. 
      Set-VSTeamDefaultProject -Project Testing

      Add-VSTeamAccessControlEntry -SecurityNamespaceId 5a27515b-ccd7-42c9-84f1-54c998f03866 -Descriptor abc -Token xyz -AllowMask 12 -DenyMask 15

      It 'Should return ACEs' {
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/5a27515b-ccd7-42c9-84f1-54c998f03866*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Body -like "*`"token`": `"xyz`",*" -and
            $Body -like "*`"descriptor`": `"abc`",*" -and
            $Body -like "*`"allow`": 12,*" -and
            $Body -like "*`"deny`": 15,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }
   }

   Context 'Add-VSTeamAccessControlEntry by SecurityNamespace' {
      Mock Get-VSTeamSecurityNamespace { return $securityNamespaceObject }
      Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

      $securityNamespace = Get-VSTeamSecurityNamespace -Id "58450c49-b02d-465a-ab12-59ae512d6531"
      Add-VSTeamAccessControlEntry -SecurityNamespace $securityNamespace -Descriptor abc -Token xyz -AllowMask 12 -DenyMask 15

      It 'Should return ACEs' {
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/58450c49-b02d-465a-ab12-59ae512d6531*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Body -like "*`"token`": `"xyz`",*" -and
            $Body -like "*`"descriptor`": `"abc`",*" -and
            $Body -like "*`"allow`": 12,*" -and
            $Body -like "*`"deny`": 15,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }
   }

   Context 'Add-VSTeamAccessControlEntry by SecurityNamespace (pipeline)' {
      Mock Get-VSTeamSecurityNamespace { return $securityNamespaceObject }
      Mock Invoke-RestMethod { return $accessControlEntryResult } -Verifiable

      Get-VSTeamSecurityNamespace -Id "58450c49-b02d-465a-ab12-59ae512d6531" | `
         Add-VSTeamAccessControlEntry -Descriptor abc -Token xyz -AllowMask 12 -DenyMask 15

      It 'Should return ACEs' {
         Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/58450c49-b02d-465a-ab12-59ae512d6531*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
            $Body -like "*`"token`": `"xyz`",*" -and
            $Body -like "*`"descriptor`": `"abc`",*" -and
            $Body -like "*`"allow`": 12,*" -and
            $Body -like "*`"deny`": 15,*" -and
            $ContentType -eq "application/json" -and
            $Method -eq "Post"
         }
      }
   }

   Context 'Add-VSTeamAccessControlEntry by securityNamespaceId throws' {
      Mock Invoke-RestMethod { throw 'Error' }

      It 'Should throw' {
         { Add-VSTeamAccessControlEntry -SecurityNamespaceId 5a27515b-ccd7-42c9-84f1-54c998f03866 -Descriptor abc -Token xyz -AllowMask 12 -DenyMask 15 } | Should Throw
      }
   }

   Context 'Add-VSTeamAccessControlEntry by SecurityNamespace throws' {
      Mock Get-VSTeamSecurityNamespace { return $securityNamespaceObject }
      Mock Invoke-RestMethod { throw 'Error' }

      $securityNamespace = Get-VSTeamSecurityNamespace -Id "5a27515b-ccd7-42c9-84f1-54c998f03866"

      It 'Should throw' {
         { Add-VSTeamAccessControlEntry -SecurityNamespace $securityNamespace -Descriptor abc -Token xyz -AllowMask 12 -DenyMask 15 } | Should Throw
      }
   }
}