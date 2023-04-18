Set-StrictMode -Version Latest

Describe 'VSTeamKubernetesEndpoint' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Add-VSTeamServiceEndpoint.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamServiceEndpoint.ps1"
   }

   Context 'Add-VSTeamKubernetesEndpoint' {
      BeforeAll {
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'ServiceEndpoints' }
         Mock Set-VSTeamAccount -ModuleName $moduleName { return $null }
         Mock Set-VSTeamDefaultProject -ModuleName $moduleName { return $null }
         Mock Get-VSTeamProject -ModuleName $moduleName { return @{
                 Id = "2c01ff81-274b-4831-b001-c894cfb795bb" }}
         Mock Write-Progress
         Mock Invoke-RestMethod { _trackProcess }
         Mock Invoke-RestMethod { return @{id = '23233-2342' } } -ParameterFilter { $Method -eq 'Post' }
      }

      It 'not accepting untrusted certs and not generating a pfx should create a new Kubernetes Serviceendpoint' {
         Add-VSTeamKubernetesEndpoint -projectName 'project' `
            -endpointName 'KubTest' `
            -kubernetesUrl 'http://myK8s.local' `
            -clientKeyData '00000000-0000-0000-0000-000000000000' `
            -kubeconfig '{name: "myConfig"}' `
            -clientCertificateData 'someClientCertData'

         # On PowerShell 5 the JSON has two spaces but on PowerShell 6 it only has one so
         # test for both.
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            ($Body -like '*"acceptUntrustedCerts":  false*' -or $Body -like '*"acceptUntrustedCerts": false*') -and
            ($Body -like '*"generatePfx":  false*' -or $Body -like '*"generatePfx": false*')
         }
      }

      It 'accepting untrusted certs and generating a pfx should create a new Kubernetes Serviceendpoint' {
         Add-VSTeamKubernetesEndpoint -projectName 'project' -endpointName 'KubTest' `
            -kubernetesUrl 'http://myK8s.local' -clientKeyData '00000000-0000-0000-0000-000000000000' `
            -kubeconfig '{name: "myConfig"}' -clientCertificateData 'someClientCertData' -acceptUntrustedCerts -generatePfx

         # On PowerShell 5 the JSON has two spaces but on PowerShell 6 it only has one so
         # test for both.
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            ($Body -like '*"acceptUntrustedCerts":  true*' -or $Body -like '*"acceptUntrustedCerts": true*') -and
            ($Body -like '*"generatePfx":  true*' -or $Body -like '*"generatePfx": true*')
         }
      }
   }
}
