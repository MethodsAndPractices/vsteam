Set-StrictMode -Version Latest

Describe 'VSTeamPolicy' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   
      . "$baseFolder/Source/Classes/VSTeamLeaf.ps1"
      . "$baseFolder/Source/Classes/VSTeamDirectory.ps1"
      . "$baseFolder/Source/Classes/VSTeamTask.ps1"
      . "$baseFolder/Source/Classes/VSTeamAttempt.ps1"
      . "$baseFolder/Source/Classes/VSTeamEnvironment.ps1"
      . "$baseFolder/Source/Private/applyTypes.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"
      
      ## Arrange
      $results = [PSCustomObject]@{
         value = [PSCustomObject]@{ }
      }

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Invoke-RestMethod { return $results }
      Mock Invoke-RestMethod { throw 'Error' } -ParameterFilter { $Uri -like "*boom*" }
   }

   Context 'Get-VSTeamPolicy' {
      It 'by project should return policies' {
         ## Act
         Get-VSTeamPolicy -ProjectName Demo

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/Demo/_apis/policy/configurations?api-version=$(_getApiVersion Git)"
         }
      }

      It 'by project and id should return the policy' {
         ## Act
         Get-VSTeamPolicy -ProjectName Demo -Id 4

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/Demo/_apis/policy/configurations/4?api-version=$(_getApiVersion Git)"
         }
      }

      It 'by project should throw' {
         ## Act / Assert
         { Get-VSTeamPolicy -ProjectName boom } | Should -Throw
      }

      It 'by project and id throws should throw' {
         ## Act / Assert
         { Get-VSTeamPolicy -ProjectName boom -Id 4 } | Should -Throw
      }
   }
}