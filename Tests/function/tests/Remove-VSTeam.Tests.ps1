Set-StrictMode -Version Latest

Describe "VSTeam" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath      
      . "$baseFolder/Source/Public/Get-VSTeam.ps1"

      Mock _callAPI
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
      Mock Get-VSTeam { return New-Object -TypeName PSObject -Prop @{projectname = "TestProject"; name = "TestTeam" } }
   }

   Context "Remove-VSTeam" {
      It 'Should remove the team' {
         Remove-VSTeam -ProjectName Test -TeamId "TestTeam" -Force

         Should -Invoke _callAPI -Exactly 1 -Scope It -ParameterFilter {
            $Resource -eq 'projects/Test/teams' -and
            $Version -eq '1.0-unitTests' -and
            $Id -eq 'TestTeam' -and
            $Method -eq "Delete"
         }
      }

      It 'fed through pipeline Should remove the team' {
         Get-VSTeam -ProjectName TestProject -TeamId "TestTeam" | Remove-VSTeam -Force

         Should -Invoke _callAPI -Exactly 1 -Scope It -ParameterFilter {
            $Resource -eq 'projects/TestProject/teams' -and
            $Version -eq '1.0-unitTests' -and
            $Id -eq 'TestTeam' -and
            $Method -eq "Delete"
         }
      }
   }
}