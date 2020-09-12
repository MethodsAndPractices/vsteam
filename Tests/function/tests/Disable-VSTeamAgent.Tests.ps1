Set-StrictMode -Version Latest

Describe 'VSTeamAgent' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange      
      Mock _callAPI
      Mock _handleException
      Mock _callAPI { throw 'boom' } -ParameterFilter { $id -eq "101" }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }
   }

   Context 'Disable-VSTeamAgent' {
      It 'should handle exception' {
         ## Act
         Disable-VSTeamAgent -Pool 36 -Id 101 -Force

         ##Assert
         Should -Invoke _handleException -Exactly -Times 1 -Scope It
      }

      It 'should disable the agent with passed in Id' {
         ## Act
         Disable-VSTeamAgent -Pool 36 -Id 950 -Force

         ## Assert
         Should -Invoke _callAPI -Exactly -Times 1 -Scope It -ParameterFilter {
            $method -eq 'PATCH' -and
            $NoProject -eq $true -and
            $area -eq 'distributedtask/pools/36' -and
            $resource -eq 'agents' -and
            $id -eq 950 -and
            $body -eq "{'enabled':false,'id':950,'maxParallelism':1}" -and
            $version -eq '1.0-unitTests'
         }
      }
   }
}
