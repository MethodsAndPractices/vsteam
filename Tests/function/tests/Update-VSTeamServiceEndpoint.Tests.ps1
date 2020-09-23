Set-StrictMode -Version Latest

Describe 'VSTeamServiceEndpoint' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamServiceEndpoint.ps1"
   }

   Context 'Update-VSTeamServiceEndpoint' {
      BeforeAll {
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter {
            $Service -eq 'ServiceEndpoints' 
         }

         Mock Write-Progress
         Mock Invoke-RestMethod { _trackProcess }
         Mock Invoke-RestMethod { return @{id = '23233-2342' } } -ParameterFilter { 
            $Method -eq 'Get' -or
            $Method -eq 'Put'
         }
      }

      It 'should update Serviceendpoint' {
         ## Act
         Update-VSTeamServiceEndpoint -projectName 'project' `
            -id '23233-2342' `
            -object @{ key = 'value' }

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Put'
         }
      }
   }
}