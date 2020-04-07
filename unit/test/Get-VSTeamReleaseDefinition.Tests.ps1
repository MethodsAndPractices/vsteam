Set-StrictMode -Version Latest
# Loading System.Web avoids issues finding System.Web.HttpUtility
Add-Type -AssemblyName 'System.Web'
$env:testing=$true
# The InModuleScope command allows you to perform white-box unit testing on the
# internal \(non-exported\) code of a Script Module, ensuring the module is loaded.
InModuleScope VSTeam {
   $results = Get-Content "$PSScriptRoot\sampleFiles\releaseDefAzD.json" -Raw | ConvertFrom-Json

   Describe 'Get-VSTeamReleaseDefinition' {
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
      [VSTeamVersions]::Release = '1.0-unittest'

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'no parameters' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod {
            return $results
         }

         It 'should return Release definitions' {
            Get-VSTeamReleaseDefinition -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions?api-version=$([VSTeamVersions]::Release)"
            }
         }
      }

      Context 'expand environments' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod {
            return $results
         }

         It 'should return Release definitions' {
            Get-VSTeamReleaseDefinition -projectName project -expand environments

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions?api-version=$([VSTeamVersions]::Release)&`$expand=environments"
            }
         }
      }

      Context 'by ID' {
         Mock Invoke-RestMethod { return $results.value[0] }

         It 'should return Release definition' {
            Get-VSTeamReleaseDefinition -projectName project -id 15

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/definitions/15?api-version=$([VSTeamVersions]::Release)"
            }
         }
      }

      # Make sure these test run last as the need differnt
      # [VSTeamVersions]::Account values
      Context 'no account' {
         [VSTeamVersions]::Account = $null

         It 'should return Release definitions' {
            { Get-VSTeamReleaseDefinition -projectName project } | Should Throw
         }
      }
   }
}