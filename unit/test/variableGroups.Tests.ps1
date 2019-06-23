Set-StrictMode -Version Latest

InModuleScope VSTeam {
   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

   # Variable Groups are not supported on TFS 2017
   Describe "Variable Groups TFS 2017 Errors" {
      Context 'Get-VSTeamVariableGroup' {
         It 'Should throw' {
            Set-VSTeamAPIVersion TFS2017

            { Get-VSTeamVariableGroup -projectName project } | Should Throw
         }
      }

      Context 'Remove-VSTeamVariableGroup' {
         It 'Should throw' {
            Set-VSTeamAPIVersion TFS2017

            { Remove-VSTeamVariableGroup -projectName project -id 5 } | Should Throw
         }
      }

      Context 'Add-VSTeamVariableGroup' {
         It 'Should throw' {
            Set-VSTeamAPIVersion TFS2017
            $testParameters = @{
               ProjectName               = "project"
               variableGroupName         = "az-keyvault"
               variableGroupDescription  = "description"
               variableGroupType         = "AzureKeyVault"
               variableGroupVariables    = @{
                  name_of_existing_secret = @{
                     enabled     = $true
                     contentType = ""
                     value       = ""
                     isSecret    = $true
                  }
               }
               variableGroupProviderData = @{
                  serviceEndpointId = "1cda0ec8-8f46-4a38-8b06-16068b8c47fc"
                  vault             = "az-keyvault"
               }
            }

            { Add-VSTeamVariableGroup @testParameters } | Should Throw
         }
      }

      Context 'Update-VSTeamVariableGroup' {
         It 'Should throw' {
            Set-VSTeamAPIVersion TFS2017
            $testParameters = @{
               ProjectName               = "project"
               id                        = 5
               variableGroupName         = "az-keyvault"
               variableGroupDescription  = "description"
               variableGroupType         = "AzureKeyVault"
               variableGroupVariables    = @{
                  name_of_existing_secret = @{
                     enabled     = $true
                     contentType = ""
                     value       = ""
                     isSecret    = $true
                  }
                  name_of_second_secret   = @{
                     enabled     = $true
                     contentType = ""
                     value       = ""
                     isSecret    = $true
                  }
               }
               variableGroupProviderData = @{
                  serviceEndpointId = "1cda0ec8-8f46-4a38-8b06-16068b8c47fc"
                  vault             = "az-keyvault"
               }
            }

            { Update-VSTeamVariableGroup @testParameters } | Should Throw
         }
      }
   }

   Describe 'Variable Groups VSTS' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/project*"
      }

      . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

      [VSTeamVersions]::VariableGroups = '5.0-preview.1'

      Context 'Get-VSTeamVariableGroup list' {
         Mock Invoke-RestMethod {
            return [PSCustomObject]@{
               value = [PSCustomObject]@{
                  id           = 5
                  type         = "AzureKeyVault"
                  name         = "az-keyvault"
                  createdBy    = [PSCustomObject]@{}
                  modifiedBy   = [PSCustomObject]@{}
                  providerData = [PSCustomObject]@{}
                  variables    = [PSCustomObject]@{}
               }
            }
         }

         It 'Should return all variable groups' {
            Get-VSTeamVariableGroup -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/?api-version=$([VSTeamVersions]::VariableGroups)"
            }
         }
      }

      Context 'Get-VSTeamVariableGroup id' {
         Mock Invoke-RestMethod {
            return [PSCustomObject]@{
               id           = 5
               type         = "AzureKeyVault"
               name         = "az-keyvault"
               createdBy    = [PSCustomObject]@{}
               modifiedBy   = [PSCustomObject]@{}
               providerData = [PSCustomObject]@{}
               variables    = [PSCustomObject]@{}
            }
         }

         It 'Should return one variable group' {
            Get-VSTeamVariableGroup -projectName project -id 5

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/5?api-version=$([VSTeamVersions]::VariableGroups)"
            }
         }
      }

      Context 'Remove-VSTeamVariableGroup' {
         Mock Invoke-RestMethod

         It 'should delete service endpoint' {
            Remove-VSTeamVariableGroup -projectName project -id 5 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/5?api-version=$([VSTeamVersions]::VariableGroups)" -and
               $Method -eq 'Delete'
            }
         }
      }

      Context 'Add-VSTeamVariableGroup' {
         Mock Invoke-RestMethod {
            return [PSCustomObject]@{
               id           = 5
               type         = "AzureKeyVault"
               name         = "az-keyvault"
               createdBy    = [PSCustomObject]@{}
               modifiedBy   = [PSCustomObject]@{}
               providerData = [PSCustomObject]@{}
               variables    = [PSCustomObject]@{}
            }
         } -Verifiable

         It 'should create a new AzureRM Key Vault Variable Group' {
            $testParameters = @{
               ProjectName               = "project"
               variableGroupName         = "az-keyvault"
               variableGroupDescription  = "description"
               variableGroupType         = "AzureKeyVault"
               variableGroupVariables    = @{
                  name_of_existing_secret = @{
                     enabled     = $true
                     contentType = ""
                     value       = ""
                     isSecret    = $true
                  }
               }
               variableGroupProviderData = @{
                  serviceEndpointId = "1cda0ec8-8f46-4a38-8b06-16068b8c47fc"
                  vault             = "az-keyvault"
               }
            }

            Add-VSTeamVariableGroup @testParameters

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }
      }

      Context 'Update-VSTeamVariableGroup' {
         Mock Invoke-RestMethod {
            return [PSCustomObject]@{
               id           = 5
               type         = "AzureKeyVault"
               name         = "az-keyvault"
               createdBy    = [PSCustomObject]@{}
               modifiedBy   = [PSCustomObject]@{}
               providerData = [PSCustomObject]@{}
               variables    = [PSCustomObject]@{}
            }
         } -Verifiable

         It 'should update an exisiting Variable Group' {
            $testParameters = @{
               ProjectName               = "project"
               id                        = 5
               variableGroupName         = "az-keyvault"
               variableGroupDescription  = "description"
               variableGroupType         = "AzureKeyVault"
               variableGroupVariables    = @{
                  name_of_existing_secret = @{
                     enabled     = $true
                     contentType = ""
                     value       = ""
                     isSecret    = $true
                  }
                  name_of_second_secret   = @{
                     enabled     = $true
                     contentType = ""
                     value       = ""
                     isSecret    = $true
                  }
               }
               variableGroupProviderData = @{
                  serviceEndpointId = "1cda0ec8-8f46-4a38-8b06-16068b8c47fc"
                  vault             = "az-keyvault"
               }
            }

            Update-VSTeamVariableGroup @testParameters

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Put' }
         }
      }
   }
}
