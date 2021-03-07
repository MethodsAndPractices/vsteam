Set-StrictMode -Version Latest

Describe 'VSTeamRelease' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { $Service -eq 'Release' }
   }

   Context 'Remove-VSTeamRelease' {
      BeforeAll {
         Mock Invoke-RestMethod
         Mock Invoke-RestMethod { throw 'error' } -ParameterFilter { $Uri -like "*101*" }
      }

      It 'by Id should remove release' {
         ## Act
         Remove-VSTeamRelease -ProjectName VSTeamRelease -Id 15 -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Delete' -and
            $Uri -eq "https://vsrm.dev.azure.com/test/VSTeamRelease/_apis/release/releases/15?api-version=$(_getApiVersion Release)"
         }
      }

      It 'by Id should throw' {
         ## Act / Assert
         { Remove-VSTeamRelease -ProjectName VSTeamRelease -Id 101 -Force } | Should -Throw
      }
   }
}