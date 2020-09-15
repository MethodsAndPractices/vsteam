Set-StrictMode -Version Latest

Describe 'VSTeamServiceFabricEndpoint' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Add-VSTeamServiceEndpoint.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamServiceEndpoint.ps1"
   }

   Context 'Add-VSTeamServiceFabricEndpoint' {
      Context 'Services' {
         BeforeAll {
            Mock _getInstance { return 'https://dev.azure.com/test' }
            Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'ServiceEndpoints' }

            Mock Write-Progress
            Mock Invoke-RestMethod { _trackProcess }
            Mock Invoke-RestMethod { return @{id = '23233-2342' } } -ParameterFilter { $Method -eq 'Post' }
         }

         It 'should create a new Service Fabric Serviceendpoint' {
            Add-VSTeamServiceFabricEndpoint -projectName 'project' `
               -endpointName 'PM_DonovanBrown' `
               -url "tcp://0.0.0.0:19000" `
               -useWindowsSecurity $false

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }

         It 'with AzureAD authentication should create a new Service Fabric Serviceendpoint' {
            $password = '00000000-0000-0000-0000-000000000000' | ConvertTo-SecureString -AsPlainText -Force
            $username = "Test User"
            $serverCertThumbprint = "0000000000000000000000000000000000000000"

            Add-VSTeamServiceFabricEndpoint -projectName 'project' `
               -endpointName 'PM_DonovanBrown' `
               -url "tcp://0.0.0.0:19000" `
               -username $username `
               -password $password `
               -serverCertThumbprint $serverCertThumbprint

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }

         It 'with Certificate authentication should create a new Service Fabric Serviceendpoint' {
            $password = '00000000-0000-0000-0000-000000000000' | ConvertTo-SecureString -AsPlainText -Force
            $base64Cert = "0000000000000000000000000000000000000000"
            $serverCertThumbprint = "0000000000000000000000000000000000000000"

            Add-VSTeamServiceFabricEndpoint -projectName 'project' `
               -endpointName 'PM_DonovanBrown' `
               -url "tcp://0.0.0.0:19000" `
               -serverCertThumbprint $serverCertThumbprint `
               -certificate $base64Cert `
               -certificatePassword $password

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }
      }

      Context 'Server' {
         BeforeAll {
            Mock _getApiVersion { return 'TFS2017' }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
            Mock _getApiVersion { return '' } -ParameterFilter { $Service -eq 'ServiceEndpoints' }
         }

         Context 'Add-VSTeamServiceFabricEndpoint' {
            BeforeAll {
               Mock Add-VSTeamServiceEndpoint -ParameterFilter {
                  $endpointType -eq 'servicefabric'
               }
            }

            # Service Fabric is supported on all VSTeam supported versions of TFS
            It 'Should not throw' {
               { Add-VSTeamServiceFabricEndpoint -projectName 'project' `
                     -endpointName 'PM_DonovanBrown' `
                     -url "tcp://0.0.0.0:19000" `
                     -useWindowsSecurity $false } | Should -Not -Throw
            }

            It 'Add-VSTeamServiceEndpoint should be called' {
               Should -Invoke Add-VSTeamServiceEndpoint -Exactly -Times 1 -Scope Context
            }
         }
      }
   }
}
