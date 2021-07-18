Set-StrictMode -Version Latest

Describe 'VSTeamPipelineAuthorization' -Tag 'unit', 'pipeline', 'security' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com' }

      Mock Invoke-RestMethod {
         return $null
      }

      Mock _getInstance { return "https://dev.azure.com/TestOrg01" }
      Mock _getApiVersion { return '5.1-preview.1' } -ParameterFilter { $Service -eq '' }
   }

   Context 'Set-VSTeamPipelineAuthorization' {
      It 'should set  pipeline' {
         Set-VSTeamPipelineAuthorization 
         
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 `
            -ParameterFilter {
            $Method -eq 'Patch'
         }
      }
   }
}
