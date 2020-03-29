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
   $results = [PSCustomObject]@{
      value = [PSCustomObject]@{ }
   }

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' }

   Mock Invoke-RestMethod { return $results }
   Mock Invoke-RestMethod { throw 'Error' } -ParameterFilter { $Uri -like "*boom*" }

   Context 'Get-VSTeamPolicy' {
      It 'by project should return policies' {
         ## Act
         Get-VSTeamPolicy -ProjectName Demo
         
         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/Demo/_apis/policy/configurations?api-version=$(_getApiVersion Git)"
         }
      }

      It 'by project and id should return the policy' {
         ## Act
         Get-VSTeamPolicy -ProjectName Demo -Id 4
         
         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/Demo/_apis/policy/configurations/4?api-version=$(_getApiVersion Git)"
         }
      }

      It 'by project should throw' {
         ## Act / Assert
         { Get-VSTeamPolicy -ProjectName boom } | Should Throw
      }

      It 'by project and id throws should throw' {
         ## Act / Assert
         { Get-VSTeamPolicy -ProjectName boom -Id 4 } | Should Throw
      }
   }
}