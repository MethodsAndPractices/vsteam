Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\serviceendpoints.psm1 -Force

InModuleScope serviceendpoints {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

   Describe 'ServiceEndpoints' {
      . "$PSScriptRoot\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Get-VSTeamServiceEndpoint' {
         Mock Write-Verbose
         Mock Invoke-RestMethod {
            return @{
               value = @{
                  createdBy       = @{}
                  authorization   = @{}
                  data            = @{}
                  operationStatus = @{
                     state         = 'Failed'
                     statusMessage = 'Bad things!'
                  }
               }
            }}

         It 'Should return all service endpoints' {
            Get-VSTeamServiceEndpoint -projectName project -Verbose

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/distributedtask/serviceendpoints/?api-version=$($VSTeamVersionTable.DistributedTask)"
            }
         }
      }

      Context 'Remove-VSTeamServiceEndpoint' {
         Mock Invoke-RestMethod -UserAgent (_getUserAgent)

         It 'should delete service endpoint' {
            Remove-VSTeamServiceEndpoint -projectName project -id 5 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/distributedtask/serviceendpoints/5?api-version=$($VSTeamVersionTable.DistributedTask)" -and
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
            if ($i -gt 9) {
               return @{
                  isReady         = $true
                  operationStatus = @{state = 'Ready'}
               }
            }

            return @{
               isReady         = $false
               createdBy       = @{}
               authorization   = @{}
               data            = @{}
               operationStatus = @{state = 'InProgress'}
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
            if ($i -gt 9) {
               return @{
                  isReady         = $true
                  operationStatus = @{state = 'Ready'}
               }
            }

            return @{
               isReady         = $false
               createdBy       = @{}
               authorization   = @{}
               data            = @{}
               operationStatus = @{state = 'InProgress'}
            }
         }

         It 'should create a new SonarQube Serviceendpoint' {
            Add-VSTeamSonarQubeEndpoint -projectName 'project' -endpointName 'PM_DonovanBrown' -sonarqubeUrl 'http://mysonarserver.local' -personalAccessToken '00000000-0000-0000-0000-000000000000'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }
      }

      Context 'Add-VSTeamSonarQubeEndpoint with securePersonalAccessToken' {
         Mock Write-Progress
         Mock Invoke-RestMethod { return @{id = '23233-2342'} } -ParameterFilter { $Method -eq 'Post'}
         Mock Invoke-RestMethod {

            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($i -gt 9) {
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
            if ($i -gt 9) {
               return @{
                  isReady         = $false
                  operationStatus = @{
                     state         = 'Failed'
                     statusMessage = 'Simulated failed request'
                  }
               }
            }

            return @{
               isReady         = $false
               createdBy       = @{}
               authorization   = @{}
               data            = @{}
               operationStatus = @{state = 'InProgress'}
            }
         }

         It 'should not create a new AzureRM Serviceendpoint' {
            {
               Add-VSTeamAzureRMServiceEndpoint -projectName 'project' `
                  -displayName 'PM_DonovanBrown' -subscriptionId '00000000-0000-0000-0000-000000000000' `
                  -subscriptionTenantId '00000000-0000-0000-0000-000000000000'
            } | Should Throw

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }
      }
   }
}