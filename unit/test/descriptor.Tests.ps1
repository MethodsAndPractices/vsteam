Set-StrictMode -Version Latest

InModuleScope VSTeam {

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

   $result = Get-Content "$PSScriptRoot\sampleFiles\descriptor.scope.TestProject.json" -Raw | ConvertFrom-Json

   Describe 'Descriptor VSTS' {

      Context 'Get-VSTeamDescriptor by StorageKey' {
         Mock Invoke-RestMethod { return $result } -Verifiable

         Get-VSTeamDescriptor -StorageKey '010d06f0-00d5-472a-bb47-58947c230876'

         It 'Should return groups' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -eq "https://vssps.dev.azure.com/test/_apis/graph/descriptors/010d06f0-00d5-472a-bb47-58947c230876?api-version=$([VSTeamVersions]::Graph)"
            }
         }
      }

      Context 'Get-VSTeamDescriptor by StorageKey throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Get-VSTeamDescriptor -StorageKey Demo } | Should Throw
         }
      }
   }
}