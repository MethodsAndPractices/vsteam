Set-StrictMode -Version Latest

Describe 'VSTeamVariableGroup' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Set-VSTeamVariableGroupVariable' {
      Context 'Services' {
         BeforeAll {
            Mock _getApiVersion { return 'VSTS' }
            Mock _getInstance { return 'https://dev.azure.com/test' }
            Mock Get-VSTeamVariableGroup { @(@{
               name = "TheGroup";
               id = 101;
               variables = @{
                  "x" = @{value="A"};
                  "y" = @{value="B"};
                  "s" = @{value=$null; isSecret=$True}
               }
            }) | ConvertTo-JSON | ConvertFrom-JSON}
            Mock _getApiVersion { return '5.0-preview.1-unitTests' } -ParameterFilter { $Service -eq 'VariableGroups' }
            Mock Update-VSTeamVariableGroup {}
            Mock Write-Error {}
         }

         It 'should change the value of an exisiting variable' {
            Set-VSTeamVariableGroupVariable -ProjectName project -GroupName TheGroup -Name x -Value NewValue -Force

            Should -Invoke Update-VSTeamVariableGroup -Exactly -Scope It -Times 1 -ParameterFilter {
               ($Body | ConvertFrom-JSON).variables.x.value -eq "NewValue"
            }
         }

         It 'should create a new variable' {
            Set-VSTeamVariableGroupVariable -ProjectName project -GroupName TheGroup -Name z -Value ANewOne -Force

            Should -Invoke Update-VSTeamVariableGroup -Exactly -Scope It -Times 1 -ParameterFilter {
               ($Body | ConvertFrom-JSON).variables.z.value -eq "ANewOne"
            }
         }

         It 'should fail on nonexistent group' {
            Set-VSTeamVariableGroupVariable -ProjectName project -GroupName NotAGroup -Name z -Value ANewOne -Force
            Should -Invoke Write-Error -Exactly -Scope It -Times 1
         }

         It 'should fail on a secret var' {
            Set-VSTeamVariableGroupVariable -ProjectName project -GroupName TheGroup -Name s -Value NewValue -Force
            Should -Invoke Write-Error -Exactly -Scope It -Times 1
         }
      }
   }
}
