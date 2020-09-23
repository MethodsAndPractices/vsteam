Set-StrictMode -Version Latest

Describe 'VSTeamOption' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Get-VSTeamOption' {
      BeforeAll {
         ## Arrange
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamOption-Area_git-Resource_annotatedTags.json' }
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