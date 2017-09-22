Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\serviceendpoints.psm1 -Force

InModuleScope serviceendpoints {
   $env:TEAM_ACCT = 'https://test.visualstudio.com'

   Describe 'ServiceEndpoints' {
      . "$PSScriptRoot\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Get-ServiceEndpoint' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  createdBy=@{}
                  authorization=@{}
                  data=@{}
                  operationStatus=@{}
               }
            }}

         It 'Should return all service endpoints' {
            Get-ServiceEndpoint -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq 'https://test.visualstudio.com/DefaultCollection/project/_apis/distributedtask/serviceendpoints?api-version=3.0-preview.1'
            }
         }
      }

      Context 'Remove-ServiceEndpoint' {
         Mock Invoke-RestMethod -UserAgent (_getUserAgent)

         It 'should delete service endpoint'{
            Remove-ServiceEndpoint -projectName project -id 5 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq 'https://test.visualstudio.com/DefaultCollection/project/_apis/distributedtask/serviceendpoints/5?api-version=3.0-preview.1' -and `
               $Method -eq 'Delete'
            }
         }
      }

      Context 'Add-AzureRMServiceEndpoint' {
         Mock Write-Progress
         Mock Invoke-RestMethod { return @{id='23233-2342'} } -ParameterFilter { $Method -eq 'Post'}
         Mock Invoke-RestMethod {

            # This $i is in the module. Because we use InModuleScope
            # we can see it
            if ($i -gt 9) {
               return @{
                  isReady=$true
                  operationStatus=@{state='Ready'}
               }
            }

            return @{
               isReady=$false
               createdBy=@{}
               authorization=@{}
               data=@{}
               operationStatus=@{state='InProgress'}
            }
         }

         It 'should create a new AzureRM Serviceendpoint' {
            Add-AzureRMServiceEndpoint -projectName 'project' -displayName 'PM_DonovanBrown' -subscriptionId '121d7d3b-2911-4154-9aa8-65132fe82e74' -subscriptionTenantId '72f988bf-86f1-41af-91ab-2d7cd011db47'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }
      }

        Context 'Add-SonarQubeEndpoint' {
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
                Add-SonarQubeEndpoint -projectName 'project' -endpointName 'PM_DonovanBrown' -sonarqubeUrl 'http://mysonarserver.local' -personalAccessToken '72f988bf-86f1-41af-91ab-2d7cd011db47'

                Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
            }
        }
   }
}