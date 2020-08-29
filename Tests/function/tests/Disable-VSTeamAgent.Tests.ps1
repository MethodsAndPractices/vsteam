Set-StrictMode -Version Latest

Describe 'VSTeamAgent' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Disable-VSTeamAgent' {
      ## Arrange
      BeforeAll {
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTaskReleased' }

         # Mock the call to Get-Projects by the dynamic parameter for ProjectName
         Mock Invoke-RestMethod -ParameterFilter { $Uri -like "*950*" }
         Mock Invoke-RestMethod { throw 'boom' } -ParameterFilter { $Uri -like "*101*" }
      }

      It 'should throw' {
         ## Act / Assert
         { Disable-VSTeamAgent -Pool 36 -Id 101 } | Should -Throw
      }

      It 'by Id should disable the agent with passed in Id' {
         ## Act
         Disable-VSTeamAgent -Pool 36 -Id 950

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            # The write-host below is great for seeing how many ways the mock is called.
            # Write-Host "Assert Mock $Uri"
            $Method -eq 'Patch' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/36/agents/950?api-version=$(_getApiVersion DistributedTaskReleased)"
         }
      }
   }
}
