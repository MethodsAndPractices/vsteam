Set-StrictMode -Version Latest

Describe 'VSTeamServiceEndpoint' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Add-VSTeamServiceEndpoint.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamServiceEndpoint.ps1"
   }

   Context 'Update-VSTeamServiceEndpoint' {
      BeforeAll {
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'ServiceEndpoints' }

         Mock Write-Progress
         Mock Invoke-RestMethod { _trackProcess }
         Mock Invoke-RestMethod { return @{id = '23233-2342' } } -ParameterFilter { $Method -eq 'Get' }
         Mock Invoke-RestMethod { return @{id = '23233-2342' } } -ParameterFilter { $Method -eq 'Put' }
      }

      It 'should update Serviceendpoint' {
         Update-VSTeamServiceEndpoint -projectName 'project' -id '23233-2342' `
            -object @{ key = 'value' }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Put'
         }
      }
   }
}