Set-StrictMode -Version Latest

InModuleScope VSTeam {
   Describe 'Set-VSTeamAccount'{
      Context 'You cannot use -UseWindowsAuthentication with Azd' {
         Mock Write-Error { } -Verifiable

         It 'Should return error'{
            Set-VSTeamAccount -Account test -UseWindowsAuthentication
            Assert-VerifiableMock
         }
      }
   }
}