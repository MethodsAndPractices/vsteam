Set-StrictMode -Version Latest

Describe 'Remove-VSTeamBuild' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Service' {
      BeforeAll {
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         # Arrange
         Mock Invoke-RestMethod

         # Act
         Remove-VSTeamBuild -projectName VSTeamBuild -id 2 -Force
      }

      It 'should delete build' {
         # Assert
         Should -Invoke Invoke-RestMethod -Scope Context -Exactly -Times 1 -ParameterFilter {
            $Method -eq 'Delete' -and
            $Uri -eq "https://dev.azure.com/test/VSTeamBuild/_apis/build/builds/2?api-version=$(_getApiVersion Build)"
         }
      }
   }

   Context 'Server local Auth' {
      BeforeAll {
         Mock _useWindowsAuthenticationOnPremise { return $true }

         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable
         Mock Invoke-RestMethod
      }

      It 'should delete build' {
         Remove-VSTeamBuild -projectName VSTeamBuild -id 2 -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Delete' -and
            $Uri -eq "http://localhost:8080/tfs/defaultcollection/VSTeamBuild/_apis/build/builds/2?api-version=$(_getApiVersion Build)"
         }
      }
   }

   Context 'Server local Auth handles exception' {
      BeforeAll {

         # Arrange
         Mock _handleException -Verifiable
         Mock Invoke-RestMethod { throw 'Testing error handling.' }

         # Act
         Remove-VSTeamBuild -ProjectName VSTeamBuild -id 2 -Force
      }

      It 'should add tags to Build' {

         # Assert
         Should -InvokeVerifiable
      }
   }
}

