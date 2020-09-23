Set-StrictMode -Version Latest

Describe 'VSTeamAgent' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   
      Mock _handleException
      Mock _getApiVersion { return '1.0-unitTests' }
   }

   Context 'Remove-VSTeamAgent by ID' {
      BeforeAll {
         Mock _callAPI
      }

      It 'should remove the agent with passed in Id' {
         Remove-VSTeamAgent -Pool 36 -Id 950 -Force

         Should -Invoke _callAPI -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'DELETE' -and
            $Area -eq 'distributedtask/pools/36' -and
            $Resource -eq 'agents' -and
            $ID -eq 950 -and
            $Version -eq $(_getApiVersion DistributedTaskReleased)
         }
      }
   }

   Context 'Remove-VSTeamAgent throws' {
      BeforeAll {
         Mock _callAPI { throw 'boom' }
      }

      It 'should remove the agent with passed in Id' {
         Remove-VSTeamAgent -Pool 36 -Id 950 -Force
         
         Should -Invoke _handleException -Exactly -Scope It -Times 1
      }
   }
}

