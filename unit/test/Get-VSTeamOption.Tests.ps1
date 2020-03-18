Set-StrictMode -Version Latest
$env:Testing=$true
# The InModuleScope command allows you to perform white-box unit testing on the
# internal \(non-exported\) code of a Script Module, ensuring the module is loaded.
InModuleScope Vsteam {
   Describe 'Get-VSTeamOption' {
      Context 'Get-VSTeamOption' {
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

         Mock Invoke-RestMethod { return @{
               count = 1
               value = @(
                  @{
                     id           = '5e8a8081-3851-4626-b677-9891cc04102e'
                     area         = 'git'
                     resourceName = 'annotatedTags'
                  }
               )
            }
         }

         It 'Should return all options' {
            Get-VSTeamOption | Should Not Be $null
            Assert-MockCalled Invoke-RestMethod -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis"
            }
         }

         It 'Should return release options' {
            Get-VSTeamOption -subDomain vsrm | Should Not Be $null
            Assert-MockCalled Invoke-RestMethod -ParameterFilter {
               $Uri -eq "https://vsrm.dev.azure.com/test/_apis"
            }
         }
      }
   }
}