Set-StrictMode -Version Latest

Describe 'VSTeamOption' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
   
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context 'Get-VSTeamOption' {
      BeforeAll {
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
      }

      It 'Should return all options' {
         ## Act
         Get-VSTeamOption | Should -Not -Be $null

         ## Assert
         Should -Invoke Invoke-RestMethod -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis"
         }
      }

      It 'Should return release options' {
         ## Act
         Get-VSTeamOption -subDomain vsrm | Should -Not -Be $null

         ## Assert
         Should -Invoke Invoke-RestMethod -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/_apis"
         }
      }
   }
}