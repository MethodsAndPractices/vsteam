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
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Set-VSTeamDefaultProject.ps1"
. "$here/../../Source/Public/Get-VSTeamSecurityNamespace.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamAccessControlEntry' {
   ## Arrange
   # You have to set the version or the api-version will not be added when versions = ''
   [VSTeamVersions]::Core = '5.0'

   # Load sample files you need for mocks below
   $securityNamespace = Get-Content "$PSScriptRoot\sampleFiles\securityNamespace.json" -Raw | ConvertFrom-Json
   $accessControlEntryResult = Get-Content "$PSScriptRoot\sampleFiles\accessControlEntryResult.json" -Raw | ConvertFrom-Json

   # Some of the functions return VSTeam classes so turn the PSCustomeObject
   # into the correct type.
   $securityNamespaceObject = [VSTeamSecurityNamespace]::new($securityNamespace.value[0])

   Context 'Add-VSTeamAccessControlEntry' {
      ## Arrange
      # This value being left around can cause other tests to fail.
      AfterAll { $Global:PSDefaultParameterValues.Remove("*:projectName") }

      # Set the account to use for testing. A normal user would do this using the
      # Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      # This is only called when you need to test that the function can handle an
      # exception. To make sure this mock is called make sure the descriptor in
      # the body of your call has the value of 'boom'.
      Mock Invoke-RestMethod { throw 'Error' }  -ParameterFilter { $Body -like "*`"descriptor`": `"boom`",*" }

      Mock Invoke-RestMethod { return $accessControlEntryResult }

      It 'by SecurityNamespace (pipeline) should return ACEs' {
         ## Act
         $securityNamespaceObject | Add-VSTeamAccessControlEntry -Descriptor abc -Token xyz -AllowMask 12 -DenyMask 15

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            # The write-host below is great for seeing how many ways the mock is called.
            # Write-Host "Assert Mock $Uri"
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

      It 'by SecurityNamespaceId should return ACEs' {
         # Even with a default set this URI should not have the project added.
         # So set the default project to Testing here and test below that the
         # project is NOT added to the Uri.
         ## Arange
         Set-VSTeamDefaultProject -Project Testing

         ## Act
         Add-VSTeamAccessControlEntry -SecurityNamespaceId 5a27515b-ccd7-42c9-84f1-54c998f03866 -Descriptor abc -Token xyz -AllowMask 12 -DenyMask 15

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            # The write-host below is great for seeing how many ways the mock is called.
            # Write-Host "Assert Mock $Uri"
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

      It 'by SecurityNamespace should return ACEs' {
         ## Act
         Add-VSTeamAccessControlEntry -SecurityNamespace $securityNamespaceObject -Descriptor abc -Token xyz -AllowMask 12 -DenyMask 15

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            # The write-host below is great for seeing how many ways the mock is called.
            # Write-Host "Assert Mock $Uri"
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

      It 'by securityNamespaceId throws should throw' {
         ## Act / Assert
         { Add-VSTeamAccessControlEntry -SecurityNamespaceId 5a27515b-ccd7-42c9-84f1-54c998f03866 -Descriptor boom -Token xyz -AllowMask 12 -DenyMask 15 } | Should Throw
      }

      It 'by SecurityNamespace should throw' {
         ## Act / Assert
         { Add-VSTeamAccessControlEntry -SecurityNamespace $securityNamespaceObject -Descriptor boom -Token xyz -AllowMask 12 -DenyMask 15 } | Should Throw
      }
   }
}