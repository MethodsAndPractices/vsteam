Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'Get-VSTeamOption' {
   Context 'Get-VSTeamOption' {
      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

      Mock Invoke-RestMethod { return @{
            count = 1
            value = @(
               @{
                  id           = '5e8a8081-3851-4626-b677-9891cc04102e'
                  area         = 'git'
                  resourceName = 'annotatedTags'
               }
            )
         }
      }

      It 'Should return all options' {
         ## Act
         Get-VSTeamOption | Should Not Be $null

         ## Assert
         Assert-MockCalled Invoke-RestMethod -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis"
         }
      }

      It 'Should return release options' {
         ## Act
         Get-VSTeamOption -subDomain vsrm | Should Not Be $null

         ## Assert
         Assert-MockCalled Invoke-RestMethod -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/_apis"
         }
      }
   }
}