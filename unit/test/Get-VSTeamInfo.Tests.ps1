Set-StrictMode -Version Latest
$env:Testing=$true
# Loading the code from source files will break if functionality moves from one file to another, instead
# the InModuleScope command allows you to perform white-box unit testing on the
# internal \(non-exported\) code of a Script Module, ensuring the module is loaded.

InModuleScope Vsteam {
   Describe 'Get-VSTeamInfo' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      . "$PSScriptRoot\mocks\mockProjectDynamicParamMandatoryFalse.ps1"

      Context 'Get-VSTeamInfo' {
         AfterAll {
            $Global:PSDefaultParameterValues.Remove("*:projectName")
         }

         It 'should return account and default project' {
            [VSTeamVersions]::Account = "mydemos"
            $Global:PSDefaultParameterValues['*:projectName'] = 'TestProject'

            $info = Get-VSTeamInfo

            $info.Account | Should Be "mydemos"
            $info.DefaultProject | Should Be "TestProject"
         }
      }
   }
}