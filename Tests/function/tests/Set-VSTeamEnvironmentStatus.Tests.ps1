Set-StrictMode -Version Latest

Describe 'VSTeamReleaseStatus' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      
      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unittest' } -ParameterFilter { $Service -eq 'Release' }
   }

   Context 'Set-VSTeamEnvironmentStatus by ID' {
      BeforeAll {
         Mock _useWindowsAuthenticationOnPremise { return $false }
         Mock Invoke-RestMethod
         Mock Invoke-RestMethod { throw 'error' } -ParameterFilter { $Uri -like "*101*" }

         $expectedBody = ConvertTo-Json ([PSCustomObject]@{ status = 'inProgress'; comment = ''; scheduledDeploymentTime = $null })
      }

      It 'should set environments' {
         ## Act
         Set-VSTeamEnvironmentStatus -ProjectName project -ReleaseId 1 -Id 15 -Status inProgress -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -eq $expectedBody -and
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/1/environments/15?api-version=$(_getApiVersion Release)"
         }
      }

      It 'by Id should throw' {
         ## Act / Assert
         { Set-VSTeamEnvironmentStatus -ProjectName project -ReleaseId 101 -Id 101 -Status inProgress -Force } | Should -Throw
      }
   }
}