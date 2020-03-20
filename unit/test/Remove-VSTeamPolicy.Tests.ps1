Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/Get-VSTeamProject.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamPolicy' {
   ## Arrange
   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' }

   Mock Invoke-RestMethod
   Mock Invoke-RestMethod { throw 'Error' } -ParameterFilter { $Uri -like "*boom*" }

   Context 'Remove-VSTeamPolicy' {

      It 'by id should delete the policy' {
         ## Act
         Remove-VSTeamPolicy -ProjectName Demo -id 4 -Force

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'Delete' -and
            $Uri -eq "https://dev.azure.com/test/Demo/_apis/policy/configurations/4?api-version=$([VSTeamVersions]::Git)"
         }
      }

      It 'Should throw' {
         ## Act / Assert
         { Remove-VSTeamPolicy -ProjectName boom -id 4 -Force } | Should Throw
      }
   }
}