Set-StrictMode -Version Latest

Describe "VSTeamGitRepository" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Add-VSTeamGitRepository' {
      ## Arrange
      BeforeAll {
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamGitRepository.json' -Index 0 }
         Mock _getApiVersion { return '1.0-gitUnitTests' } -ParameterFilter { $Service -eq 'Git' }
      }

      It 'should add Git repo by name' {
         ## Act
         Add-VSTeamGitRepository -ProjectName 'test' `
            -Name 'testRepo'

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Post" -and
            $Uri -eq "https://dev.azure.com/test/test/_apis/git/repositories?api-version=1.0-gitUnitTests" -and
            $Body -like "*testRepo*"
         }
      }
   }
}