Set-StrictMode -Version Latest
# Loading System.Web avoids issues finding System.Web.HttpUtility
Add-Type -AssemblyName 'System.Web'
$env:testing=$true
# Loading the code from source files will break if functionality moves from one file to another, instead
# the InModuleScope command allows you to perform white-box unit testing on the
# internal \(non-exported\) code of a Script Module, ensuring the module is loaded.

InModuleScope VSTeam {
   $results = [PSCustomObject]@{
      value = [PSCustomObject]@{
         environments = [PSCustomObject]@{}
         _links       = [PSCustomObject]@{
            self = [PSCustomObject]@{}
            web  = [PSCustomObject]@{}
         }
      }
   }

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
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
      [VSTeamVersions]::Release = '1.0-unittest'

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Get-VSTeamRelease' {

      It 'by Id -Raw should return release as Raw' {
         ## Act
         $raw = Get-VSTeamRelease -ProjectName project -Id 15 -Raw

         ## Assert
         $raw | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should be 'System.Management.Automation.PSCustomObject'

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/15?api-version=$(_getApiVersion Release)"
         }
      }

      It 'by Id should return release as Object' {
         ## Act
         $r = Get-VSTeamRelease -ProjectName project -Id 15

         ## Assert
         $r | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should be 'Team.Release'

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/15?api-version=$(_getApiVersion Release)"
         }
      }

      It 'by Id -JSON should return release as JSON' {
         ## Act
         $r = Get-VSTeamRelease -ProjectName project -Id 15 -JSON

         ## Assert
         $r | Get-Member | Select-Object -First 1 -ExpandProperty TypeName | Should be 'System.String'

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases/15?api-version=$(_getApiVersion Release)"
         }
      }
   }
      Context 'Get-VSTeamRelease with no parameters' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod {
            return $results
         }

      It 'with no parameters should return releases' {
         ## Act
         Get-VSTeamRelease -projectName project

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases?api-version=$(_getApiVersion Release)"
         }
      }

      It 'with expand environments should return releases' {
         ## Act
         Get-VSTeamRelease -projectName project -expand environments

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases?api-version=$(_getApiVersion Release)&`$expand=environments"
         }
      }

      It 'with no parameters & no project should return releases' {
         ## Act
         Get-VSTeamRelease

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/_apis/release/releases?api-version=$(_getApiVersion Release)"
         }
      }
   }
   }
}