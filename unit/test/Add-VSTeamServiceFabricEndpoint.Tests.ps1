Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Add-VSTeamServiceEndpoint.ps1"
. "$here/../../Source/Public/Get-VSTeamServiceEndpoint.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamServiceFabricEndpoint' {
   Context 'Add-VSTeamServiceFabricEndpoint' {
      Mock _hasProjectCacheExpired { return $false }

      Context 'Services' {
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'ServiceFabricEndpoint' }
         
         Mock Write-Progress
         Mock Invoke-RestMethod { return @{id = '23233-2342' } } -ParameterFilter { $Method -eq 'Post' }
         Mock Invoke-RestMethod {   
            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($iTracking -gt 9) {
               return [PSCustomObject]@{
                  isReady         = $true
                  operationStatus = [PSCustomObject]@{state = 'Ready' }
               }
            }
   
            return [PSCustomObject]@{
               isReady         = $false
               createdBy       = [PSCustomObject]@{ }
               authorization   = [PSCustomObject]@{ }
               data            = [PSCustomObject]@{ }
               operationStatus = [PSCustomObject]@{state = 'InProgress' }
            }
         }
   
         It 'should create a new Service Fabric Serviceendpoint' {
            Add-VSTeamServiceFabricEndpoint -projectName 'project' -endpointName 'PM_DonovanBrown' -url "tcp://0.0.0.0:19000" -useWindowsSecurity $false
   
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }

         It 'with AzureAD authentication should create a new Service Fabric Serviceendpoint' {
            $password = '00000000-0000-0000-0000-000000000000' | ConvertTo-SecureString -AsPlainText -Force
            $username = "Test User"
            $serverCertThumbprint = "0000000000000000000000000000000000000000"
            Add-VSTeamServiceFabricEndpoint -projectName 'project' -endpointName 'PM_DonovanBrown' -url "tcp://0.0.0.0:19000" -username $username -password $password -serverCertThumbprint $serverCertThumbprint
   
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }

         It 'with Certificate authentication should create a new Service Fabric Serviceendpoint' {
            $password = '00000000-0000-0000-0000-000000000000' | ConvertTo-SecureString -AsPlainText -Force
            $base64Cert = "0000000000000000000000000000000000000000"
            $serverCertThumbprint = "0000000000000000000000000000000000000000"
            Add-VSTeamServiceFabricEndpoint -projectName 'project' -endpointName 'PM_DonovanBrown' -url "tcp://0.0.0.0:19000" -serverCertThumbprint $serverCertThumbprint -certificate $base64Cert -certificatePassword $password
   
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }
      }

      Context 'Server' {
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         Mock _getApiVersion { return 'TFS2017' }
         Mock _getApiVersion { return '' } -ParameterFilter { $Service -eq 'ServiceFabricEndpoint' }

         Context 'Add-VSTeamServiceFabricEndpoint' {
            Mock ConvertTo-Json { throw 'Should not be called' }

            It 'Should throw' {
               { Add-VSTeamServiceFabricEndpoint -projectName 'project' `
                     -endpointName 'PM_DonovanBrown' -url "tcp://0.0.0.0:19000" `
                     -useWindowsSecurity $false } | Should Throw
            }

            It 'ConvertTo-Json should not be called' {
               Assert-MockCalled ConvertTo-Json -Exactly -Times 0 -Scope Context
            }
         }
      }
   }
}