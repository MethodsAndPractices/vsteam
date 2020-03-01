Set-StrictMode -Version Latest

$env:Testing=$true
InModuleScope VSTeam {
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

   Describe 'ServiceEndpoints TFS2017 throws' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      Context 'Add-VSTeamServiceFabricEndpoint' {
         Mock ConvertTo-Json { throw 'Should not be called' } -Verifiable

         It 'Should throw' {
            Set-VSTeamAPIVersion TFS2017

            { Add-VSTeamServiceFabricEndpoint -projectName 'project' `
                  -endpointName 'PM_DonovanBrown' -url "tcp://0.0.0.0:19000" `
                  -useWindowsSecurity $false } | Should Throw
         }

         It 'ConvertTo-Json should not be called' {
            Assert-MockCalled ConvertTo-Json -Exactly 0
         }
      }
   }

   Describe 'ServiceEndpoints TFS' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Get-VSTeamServiceEndpoint' {
         Mock Write-Verbose
         Mock Invoke-RestMethod {
            return [PSCustomObject]@{
               value = [PSCustomObject]@{
                  createdBy       = [PSCustomObject]@{}
                  authorization   = [PSCustomObject]@{}
                  data            = [PSCustomObject]@{}
                  operationStatus = [PSCustomObject]@{
                     state         = 'Failed'
                     statusMessage = 'Bad things!'
                  }
               }
            }}

         It 'Should return all service endpoints' {
            Get-VSTeamServiceEndpoint -projectName project -Verbose

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/serviceendpoints?api-version=$([VSTeamVersions]::DistributedTask)"
            }
         }
      }

      Context 'Remove-VSTeamServiceEndpoint' {
         Mock Invoke-RestMethod

         It 'should delete service endpoint' {
            Remove-VSTeamServiceEndpoint -projectName project -id 5 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/serviceendpoints/5?api-version=$([VSTeamVersions]::DistributedTask)" -and
               $Method -eq 'Delete'
            }
         }
      }

      Context 'Add-VSTeamAzureRMServiceEndpoint' {
         Mock Write-Progress
         Mock Invoke-RestMethod { return @{id = '23233-2342'} } -ParameterFilter { $Method -eq 'Post'}
         Mock Invoke-RestMethod {

            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($iTracking -gt 9) {
               return [PSCustomObject]@{
                  isReady         = $true
                  operationStatus = [PSCustomObject]@{state = 'Ready'}
               }
            }

            return [PSCustomObject]@{
               isReady         = $false
               createdBy       = [PSCustomObject]@{}
               authorization   = [PSCustomObject]@{}
               data            = [PSCustomObject]@{}
               operationStatus = [PSCustomObject]@{state = 'InProgress'}
            }
         }

         It 'should create a new AzureRM Serviceendpoint' {
            Add-VSTeamAzureRMServiceEndpoint -projectName 'project' -displayName 'PM_DonovanBrown' -subscriptionId '00000000-0000-0000-0000-000000000000' -subscriptionTenantId '00000000-0000-0000-0000-000000000000'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }
      }

      Context 'Add-VSTeamSonarQubeEndpoint' {
         Mock Write-Progress
         Mock Invoke-RestMethod { return @{id = '23233-2342'} } -ParameterFilter { $Method -eq 'Post'}
         Mock Invoke-RestMethod {

            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($iTracking -gt 9) {
               return [PSCustomObject]@{
                  isReady         = $true
                  operationStatus = [PSCustomObject]@{state = 'Ready'}
               }
            }

            return [PSCustomObject]@{
               isReady         = $false
               createdBy       = [PSCustomObject]@{}
               authorization   = [PSCustomObject]@{}
               data            = [PSCustomObject]@{}
               operationStatus = [PSCustomObject]@{state = 'InProgress'}
            }
         }

         It 'should create a new SonarQube Serviceendpoint' {
            Add-VSTeamSonarQubeEndpoint -projectName 'project' -endpointName 'PM_DonovanBrown' -sonarqubeUrl 'http://mysonarserver.local' -personalAccessToken '00000000-0000-0000-0000-000000000000'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }
      }

      Context 'Add-VSTeamSonarQubeEndpoint throws on TFS' {
         Mock Write-Warning
         Mock Write-Error -Verifiable
         Mock Invoke-RestMethod {
            $e = [System.Management.Automation.ErrorRecord]::new(
               [System.Net.WebException]::new("Endpoint type couldn't be recognized 'sonarqube'", [System.Net.WebExceptionStatus]::ProtocolError),
               "Endpoint type couldn't be recognized 'sonarqube'",
               [System.Management.Automation.ErrorCategory]::ProtocolError,
               $null)

            # The error message is different on TFS and VSTS
            $msg = ConvertTo-Json @{
               '$id'   = 1
               message = "Endpoint type couldn't be recognized 'sonarqube'`r`nParameter name: endpoint.Type"
            }

            $e.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($msg)

            $PSCmdlet.ThrowTerminatingError($e)
         }

         It 'should create a new SonarQube Serviceendpoint' {
            Add-VSTeamSonarQubeEndpoint -projectName 'project' -endpointName 'PM_DonovanBrown' `
               -sonarqubeUrl 'http://mysonarserver.local' `
               -personalAccessToken '00000000-0000-0000-0000-000000000000'

            Assert-VerifiableMock
         }
      }

      Context 'Add-VSTeamSonarQubeEndpoint with securePersonalAccessToken' {
         Mock Write-Progress
         Mock Invoke-RestMethod { return @{id = '23233-2342'} } -ParameterFilter { $Method -eq 'Post'}
         Mock Invoke-RestMethod {

            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($iTracking -gt 9) {
               return [PSCustomObject]@{
                  isReady         = $true
                  operationStatus = [PSCustomObject]@{state = 'Ready'}
               }
            }

            return [PSCustomObject]@{
               isReady         = $false
               createdBy       = [PSCustomObject]@{}
               authorization   = [PSCustomObject]@{}
               data            = [PSCustomObject]@{}
               operationStatus = [PSCustomObject]@{state = 'InProgress'}
            }
         }

         It 'should create a new SonarQube Serviceendpoint' {
            $password = '00000000-0000-0000-0000-000000000000' | ConvertTo-SecureString -AsPlainText -Force

            Add-VSTeamSonarQubeEndpoint -projectName 'project' -endpointName 'PM_DonovanBrown' -sonarqubeUrl 'http://mysonarserver.local' -securePersonalAccessToken $password

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }
      }

      Context 'Add-VSTeamAzureRMServiceEndpoint-With-Failure' {
         Mock Write-Progress
         Mock Invoke-RestMethod { return @{id = '23233-2342'} } -ParameterFilter { $Method -eq 'Post'}
         Mock Invoke-RestMethod {

            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($iTracking -gt 9) {
               return [PSCustomObject]@{
                  isReady         = $false
                  operationStatus = [PSCustomObject]@{
                     state         = 'Failed'
                     statusMessage = 'Simulated failed request'
                  }
               }
            }

            return [PSCustomObject]@{
               isReady         = $false
               createdBy       = [PSCustomObject]@{}
               authorization   = [PSCustomObject]@{}
               data            = [PSCustomObject]@{}
               operationStatus = [PSCustomObject]@{state = 'InProgress'}
            }
         }

         It 'should not create a new AzureRM Serviceendpoint' {
            {
               Add-VSTeamAzureRMServiceEndpoint -projectName 'project' `
                  -displayName 'PM_DonovanBrown' -subscriptionId '00000000-0000-0000-0000-000000000000' `
                  -subscriptionTenantId '00000000-0000-0000-0000-000000000000' -servicePrincipalKey '00000000-0000-0000-0000-000000000000' -servicePrincipalId '00000000-0000-0000-0000-000000000000'
            } | Should Throw

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }
      }
   }

   Describe 'ServiceEndpoints VSTS' {
      . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

      [VSTeamVersions]::ServiceFabricEndpoint = '4.1-preview'

      Context 'Add-VSTeamServiceFabricEndpoint' {
         Mock Write-Progress
         Mock Invoke-RestMethod { return @{id = '23233-2342'} } -ParameterFilter { $Method -eq 'Post'}
         Mock Invoke-RestMethod {

            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($iTracking -gt 9) {
               return [PSCustomObject]@{
                  isReady         = $true
                  operationStatus = [PSCustomObject]@{state = 'Ready'}
               }
            }

            return [PSCustomObject]@{
               isReady         = $false
               createdBy       = [PSCustomObject]@{}
               authorization   = [PSCustomObject]@{}
               data            = [PSCustomObject]@{}
               operationStatus = [PSCustomObject]@{state = 'InProgress'}
            }
         }

         It 'should create a new Service Fabric Serviceendpoint' {
            Add-VSTeamServiceFabricEndpoint -projectName 'project' -endpointName 'PM_DonovanBrown' -url "tcp://0.0.0.0:19000" -useWindowsSecurity $false

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }
      }

      Context 'Add-VSTeamSonarQubeEndpoint throws on VSTS' {
         Mock Write-Warning
         Mock Write-Error -Verifiable
         Mock Invoke-RestMethod {
            $e = [System.Management.Automation.ErrorRecord]::new(
               [System.Net.WebException]::new("Endpoint type couldn't be recognized 'sonarqube'", [System.Net.WebExceptionStatus]::ProtocolError),
               "Endpoint type couldn't be recognized 'sonarqube'",
               [System.Management.Automation.ErrorCategory]::ProtocolError,
               $null)

            # The error message is different on TFS and VSTS
            $msg = ConvertTo-Json @{
               '$id'   = 1
               message = "Unable to find service endpoint type 'sonarqube' using authentication scheme 'UsernamePassword'."
            }

            $e.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($msg)

            $PSCmdlet.ThrowTerminatingError($e)
         }

         It 'should create a new SonarQube Serviceendpoint' {
            Add-VSTeamSonarQubeEndpoint -projectName 'project' -endpointName 'PM_DonovanBrown' -sonarqubeUrl 'http://mysonarserver.local' -personalAccessToken '00000000-0000-0000-0000-000000000000'

            Assert-VerifiableMock
         }
      }

      Context 'Add-VSTeamServiceFabricEndpoint with AzureAD authentication' {
         Mock Write-Progress
         Mock Invoke-RestMethod { return @{id = '23233-2342'} } -ParameterFilter { $Method -eq 'Post'}
         Mock Invoke-RestMethod {

            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($iTracking -gt 9) {
               return [PSCustomObject]@{
                  isReady         = $true
                  operationStatus = [PSCustomObject]@{state = 'Ready'}
               }
            }

            return [PSCustomObject]@{
               isReady         = $false
               createdBy       = [PSCustomObject]@{}
               authorization   = [PSCustomObject]@{}
               data            = [PSCustomObject]@{}
               operationStatus = [PSCustomObject]@{state = 'InProgress'}
            }
         }

         It 'should create a new Service Fabric Serviceendpoint' {
            $password = '00000000-0000-0000-0000-000000000000' | ConvertTo-SecureString -AsPlainText -Force
            $username = "Test User"
            $serverCertThumbprint = "0000000000000000000000000000000000000000"
            Add-VSTeamServiceFabricEndpoint -projectName 'project' -endpointName 'PM_DonovanBrown' -url "tcp://0.0.0.0:19000" -username $username -password $password -serverCertThumbprint $serverCertThumbprint

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }
      }

      Context 'Add-VSTeamServiceFabricEndpoint with Certificate authentication' {
         Mock Write-Progress
         Mock Invoke-RestMethod { return @{id = '23233-2342'} } -ParameterFilter { $Method -eq 'Post'}
         Mock Invoke-RestMethod {

            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($iTracking -gt 9) {
               return [PSCustomObject]@{
                  isReady         = $true
                  operationStatus = [PSCustomObject]@{state = 'Ready'}
               }
            }

            return [PSCustomObject]@{
               isReady         = $false
               createdBy       = [PSCustomObject]@{}
               authorization   = [PSCustomObject]@{}
               data            = [PSCustomObject]@{}
               operationStatus = [PSCustomObject]@{state = 'InProgress'}
            }
         }

         It 'should create a new Service Fabric Serviceendpoint' {
            $password = '00000000-0000-0000-0000-000000000000' | ConvertTo-SecureString -AsPlainText -Force
            $base64Cert = "0000000000000000000000000000000000000000"
            $serverCertThumbprint = "0000000000000000000000000000000000000000"
            Add-VSTeamServiceFabricEndpoint -projectName 'project' -endpointName 'PM_DonovanBrown' -url "tcp://0.0.0.0:19000" -serverCertThumbprint $serverCertThumbprint -certificate $base64Cert -certificatePassword $password

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }
      }

      Context 'Add-VSTeamKubernetesEndpoint not accepting untrusted certs and not generating a pfx' {
         Mock Write-Progress
         Mock Invoke-RestMethod {
            return @{id = '23233-2342'}
         } -ParameterFilter { $Method -eq 'Post'}

         Mock Invoke-RestMethod {

            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($iTracking -gt 9) {
               return [PSCustomObject]@{
                  isReady         = $true
                  operationStatus = [PSCustomObject]@{state = 'Ready'}
               }
            }

            return [PSCustomObject]@{
               isReady         = $false
               createdBy       = [PSCustomObject]@{}
               authorization   = [PSCustomObject]@{}
               data            = [PSCustomObject]@{}
               operationStatus = [PSCustomObject]@{state = 'InProgress'}
            }
         }

         It 'should create a new Kubernetes Serviceendpoint' {
            Add-VSTeamKubernetesEndpoint -projectName 'project' -endpointName 'KubTest' `
               -kubernetesUrl 'http://myK8s.local' -clientKeyData '00000000-0000-0000-0000-000000000000' `
               -kubeconfig '{name: "myConfig"}' -clientCertificateData 'someClientCertData'

            # On PowerShell 5 the JSON has two spaces but on PowerShell 6 it only has one so
            # test for both.
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               ($Body -like '*"acceptUntrustedCerts":  false*' -or $Body -like '*"acceptUntrustedCerts": false*') -and
               ($Body -like '*"generatePfx":  false*' -or $Body -like '*"generatePfx": false*')
            }
         }
      }

      Context 'Add-VSTeamKubernetesEndpoint accepting untrusted certs and generating a pfx' {
         Mock Write-Progress
         Mock Invoke-RestMethod {
            return @{id = '23233-2342'}
         } -ParameterFilter { $Method -eq 'Post'}
         Mock Invoke-RestMethod {

            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($iTracking -gt 9) {
               return [PSCustomObject]@{
                  isReady         = $true
                  operationStatus = [PSCustomObject]@{state = 'Ready'}
               }
            }

            return [PSCustomObject]@{
               isReady         = $false
               createdBy       = [PSCustomObject]@{}
               authorization   = [PSCustomObject]@{}
               data            = [PSCustomObject]@{}
               operationStatus = [PSCustomObject]@{state = 'InProgress'}
            }
         }

         It 'should create a new Kubernetes Serviceendpoint' {
            Add-VSTeamKubernetesEndpoint -projectName 'project' -endpointName 'KubTest' `
               -kubernetesUrl 'http://myK8s.local' -clientKeyData '00000000-0000-0000-0000-000000000000' `
               -kubeconfig '{name: "myConfig"}' -clientCertificateData 'someClientCertData' -acceptUntrustedCerts -generatePfx

            # On PowerShell 5 the JSON has two spaces but on PowerShell 6 it only has one so
            # test for both.
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               ($Body -like '*"acceptUntrustedCerts":  true*' -or $Body -like '*"acceptUntrustedCerts": true*') -and
               ($Body -like '*"generatePfx":  true*' -or $Body -like '*"generatePfx": true*')
            }
         }
      }

      Context 'Add-VSTeamNuGetEndpoint with ApiKey' {
         Mock Write-Progress
         Mock Invoke-RestMethod {
            return @{id = '23233-2342'}
         } -ParameterFilter { $Method -eq 'Post'}
         Mock Invoke-RestMethod {

            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($iTracking -gt 9) {
               return [PSCustomObject]@{
                  isReady         = $true
                  operationStatus = [PSCustomObject]@{state = 'Ready'}
               }
            }

            return [PSCustomObject]@{
               isReady         = $false
               createdBy       = [PSCustomObject]@{}
               authorization   = [PSCustomObject]@{}
               data            = [PSCustomObject]@{}
               operationStatus = [PSCustomObject]@{state = 'InProgress'}
            }
         }

         Add-VSTeamNuGetEndpoint -ProjectName 'project' -EndpointName 'PowerShell Gallery' -NuGetUrl 'https://www.powershellgallery.com/api/v2/package' -ApiKey '00000000-0000-0000-0000-000000000000'

         It 'should create a new NuGet Serviceendpoint' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/serviceendpoints?api-version=$([VSTeamVersions]::DistributedTask)" -and
               $Method -eq 'Post' -and
               $ContentType -eq 'application/json' -and
               $Body -like '*"nugetkey": *"00000000-0000-0000-0000-000000000000"*' -and
               $Body -like '*"scheme": *"None"*'
            }
         }
      }

      Context 'Add-VSTeamNuGetEndpoint with Username and Password' {
         Mock Write-Progress
         Mock Invoke-RestMethod {
            return @{id = '23233-2342'}
         } -ParameterFilter { $Method -eq 'Post'}
         Mock Invoke-RestMethod {

            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($iTracking -gt 9) {
               return [PSCustomObject]@{
                  isReady         = $true
                  operationStatus = [PSCustomObject]@{state = 'Ready'}
               }
            }

            return [PSCustomObject]@{
               isReady         = $false
               createdBy       = [PSCustomObject]@{}
               authorization   = [PSCustomObject]@{}
               data            = [PSCustomObject]@{}
               operationStatus = [PSCustomObject]@{state = 'InProgress'}
            }
         }

         $password = '00000000-0000-0000-0000-000000000000' | ConvertTo-SecureString -AsPlainText -Force
         Add-VSTeamNuGetEndpoint -ProjectName 'project' -EndpointName 'PowerShell Gallery' -NuGetUrl 'https://www.powershellgallery.com/api/v2/package' -Username 'testUser' -SecurePassword $password

         It 'should create a new NuGet Serviceendpoint' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/serviceendpoints?api-version=$([VSTeamVersions]::DistributedTask)" -and
               $Method -eq 'Post' -and
               $ContentType -eq 'application/json' -and
               $Body -like '*"username": *"testUser"*' -and
               $Body -like '*"password": *"00000000-0000-0000-0000-000000000000"*' -and
               $Body -like '*"scheme": *"UsernamePassword"*'
            }
         }
      }

      Context 'Add-VSTeamNuGetEndpoint with Token' {
         Mock Write-Progress

         Mock Invoke-RestMethod {
            # Write-Host "$args"
            return @{id = '23233-2342'}
         } -ParameterFilter { $Method -eq 'Post'}

         Mock Invoke-RestMethod {
            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($iTracking -gt 9) {
               return [PSCustomObject]@{
                  isReady         = $true
                  operationStatus = [PSCustomObject]@{state = 'Ready'}
               }
            }

            return [PSCustomObject]@{
               isReady         = $false
               createdBy       = [PSCustomObject]@{}
               authorization   = [PSCustomObject]@{}
               data            = [PSCustomObject]@{}
               operationStatus = [PSCustomObject]@{state = 'InProgress'}
            }
         }

         Add-VSTeamNuGetEndpoint -ProjectName 'project' -EndpointName 'PowerShell Gallery' -NuGetUrl 'https://www.powershellgallery.com/api/v2/package' -PersonalAccessToken '00000000-0000-0000-0000-000000000000'

         It 'should create a new NuGet Serviceendpoint' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/serviceendpoints?api-version=$([VSTeamVersions]::DistributedTask)" -and
               $Method -eq 'Post' -and
               $ContentType -eq 'application/json' -and
               $Body -like '*"apitoken":*"00000000-0000-0000-0000-000000000000"*' -and
               $Body -like '*"scheme":*"Token"*'
            }
         }
      }

      Context 'Update-VSTeamServiceEndpoint' {
         Mock Write-Progress
         Mock Invoke-RestMethod { return @{id = '23233-2342'} } -ParameterFilter { $Method -eq 'Get'}
         Mock Invoke-RestMethod { return @{id = '23233-2342'} } -ParameterFilter { $Method -eq 'Put'}
         Mock Invoke-RestMethod {

            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($iTracking -gt 9) {
               return [PSCustomObject]@{
                  isReady         = $true
                  operationStatus = [PSCustomObject]@{state = 'Ready'}
               }
            }

            return [PSCustomObject]@{
               isReady         = $false
               createdBy       = [PSCustomObject]@{}
               authorization   = [PSCustomObject]@{}
               data            = [PSCustomObject]@{}
               operationStatus = [PSCustomObject]@{state = 'InProgress'}
            }
         }

         It 'should update Serviceendpoint' {
            Update-VSTeamServiceEndpoint -projectName 'project' -id '23233-2342' `
               -object @{ key = 'value' }

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Put'
            }
         }
      }
   }
}