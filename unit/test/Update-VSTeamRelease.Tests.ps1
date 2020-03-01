Set-StrictMode -Version Latest

# Loading System.Web avoids issues finding System.Web.HttpUtility
Add-Type -AssemblyName 'System.Web'

$env:Testing=$true
InModuleScope VSTeam {
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'
   [VSTeamVersions]::Release = '1.0-unittest'

   $singleResult = [PSCustomObject]@{
      environments = [PSCustomObject]@{}
      variables    = [PSCustomObject]@{
         BrowserToUse = [PSCustomObject]@{
            value = "phantomjs"
         }
      }
      _links       = [PSCustomObject]@{
         self = [PSCustomObject]@{}
         web  = [PSCustomObject]@{}
      }
   }

   Describe 'Releases' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Update-VSTeamRelease' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod {
            return $singleResult
         }

         It 'should return releases' {
            $r = Get-VSTeamRelease -ProjectName project -Id 15

            $r.variables | Add-Member NoteProperty temp(@{value = 'temp'})

            Update-VSTeamRelease -ProjectName project -Id 15 -Release $r

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Put' -and
               $Body -ne $null -and
               $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/15?api-version=$([VSTeamVersions]::Release)"
            }
         }
      }
   }
}