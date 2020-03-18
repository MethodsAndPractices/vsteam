Set-StrictMode -Version Latest
$env:Testing=$true
# The InModuleScope command allows you to perform white-box unit testing on the
# internal \(non-exported\) code of a Script Module, ensuring the module is loaded.
InModuleScope vsteam {
   Describe 'Get-VSTeamResourceArea' {
      Context 'Get-VSTeamResourceArea' {
         Mock _callAPI { return @{
               value = @{ }
            }
         }

         $actual = Get-VSTeamResourceArea

         It 'Should return resources' {
            $actual | Should Not Be $null
         }
      }
   }
}