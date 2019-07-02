Set-StrictMode -Version Latest

InModuleScope VSTeam {
   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'

   $sampleFile2017 = "$PSScriptRoot\sampleFiles\variableGroupSamples2017.json"
   Describe 'Variable Groups 2017' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/project*"
      }

      . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

      [VSTeamVersions]::VariableGroups = '3.2-preview.1'

      BeforeAll {
         Set-VSTeamAPIVersion -Target TFS2017
      }

      Context 'Get-VSTeamVariableGroup list' {
         Mock Invoke-RestMethod {
            return Get-Content $sampleFile2017 | ConvertFrom-Json
         }

         It 'Should return all variable groups' {
            Get-VSTeamVariableGroup -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/?api-version=$([VSTeamVersions]::VariableGroups)"
            }
         }
      }

      Context 'Get-VSTeamVariableGroup Id' {
         Mock Invoke-RestMethod {
            #Write-Host $args

            $collection = Get-Content $sampleFile2017 | ConvertFrom-Json
            return $collection.value | Where-Object {$_.id -eq 1}
         }

         It 'Should return one variable group' {
            $projectID = 1
            Get-VSTeamVariableGroup -projectName project -id $projectID

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/$($projectID)?api-version=$([VSTeamVersions]::VariableGroups)"
            }
         }
      }

      Context 'Remove-VSTeamVariableGroup' {
         Mock Invoke-RestMethod

         It 'should delete variable group' {
            $projectID = 1
            Remove-VSTeamVariableGroup -projectName project -id $projectID -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/$($projectID)?api-version=$([VSTeamVersions]::VariableGroups)" -and
               $Method -eq 'Delete'
            }
         }
      }

      Context 'Add-VSTeamVariableGroup' {
         Mock Invoke-RestMethod {
            #Write-Host $args

            $collection = Get-Content $sampleFile2017 | ConvertFrom-Json
            return $collection.value | Where-Object {$_.id -eq 1}
         } -Verifiable

         It 'should create a new Variable Group' {
            $testParameters = @{
               ProjectName              = "project"
               Name        = "TestVariableGroup2"
               Description = "A test variable group linked to an Azure KeyVault"
               Variables   = @{
                  key1 = @{
                     value = "value"
                  }
               }
            }

            Add-VSTeamVariableGroup @testParameters

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }
      }

      Context 'Update-VSTeamVariableGroup' {
         Mock Invoke-RestMethod {
            #Write-Host $args

            $collection = Get-Content $sampleFile2017 | ConvertFrom-Json
            return $collection.value | Where-Object {$_.id -eq 1}
         } -Verifiable

         It 'should update an exisiting Variable Group' {
            $testParameters = @{
               ProjectName              = "project"
               id                       = 1
               Name        = "TestVariableGroup1"
               Description = "A test variable group"
               Variables   = @{
                  key1 = @{
                     value = "value"
                  }
                  key2 = @{
                     value    = ""
                     isSecret = $true
                  }
               }
            }

            Update-VSTeamVariableGroup @testParameters

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/$($testParameters.id)?api-version=$([VSTeamVersions]::VariableGroups)" -and
               $Method -eq 'Put'
            }
         }
      }
   }

   $sampleFileVSTS = "$PSScriptRoot\sampleFiles\variableGroupSamples.json"
   Describe 'Variable Groups VSTS' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/project*"
      }

      . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

      [VSTeamVersions]::VariableGroups = '5.0-preview.1'

      BeforeAll {
         Set-VSTeamAPIVersion -Target VSTS
      }

      Context 'Get-VSTeamVariableGroup list' {
         Mock Invoke-RestMethod {
            return Get-Content $sampleFileVSTS | ConvertFrom-Json
         }

         It 'Should return all variable groups' {
            Get-VSTeamVariableGroup -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/?api-version=$([VSTeamVersions]::VariableGroups)"
            }
         }
      }

      Context 'Get-VSTeamVariableGroup Id' {
         Mock Invoke-RestMethod {
            #Write-Host $args

            $collection = Get-Content $sampleFileVSTS | ConvertFrom-Json
            return $collection.value | Where-Object {$_.id -eq 1}
         }

         It 'Should return one variable group' {
            $projectID = 1
            Get-VSTeamVariableGroup -projectName project -id $projectID

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/$($projectID)?api-version=$([VSTeamVersions]::VariableGroups)"
            }
         }
      }

      Context 'Remove-VSTeamVariableGroup' {
         Mock Invoke-RestMethod

         It 'should delete variable group' {
            $projectID = 1
            Remove-VSTeamVariableGroup -projectName project -Id $projectID -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/$($projectID)?api-version=$([VSTeamVersions]::VariableGroups)" -and
               $Method -eq 'Delete'
            }
         }
      }

      Context 'Add-VSTeamVariableGroup' {
         Mock Invoke-RestMethod {
            #Write-Host $args

            $collection = Get-Content $sampleFileVSTS | ConvertFrom-Json
            return $collection.value | Where-Object {$_.id -eq 2}
         } -Verifiable

         It 'should create a new AzureRM Key Vault Variable Group' {
            $testParameters = @{
               ProjectName               = "project"
               Name         = "TestVariableGroup2"
               Description  = "A test variable group linked to an Azure KeyVault"
               Type         = "AzureKeyVault"
               Variables    = @{
                  key3 = @{
                     enabled     = $true
                     contentType = ""
                     value       = ""
                     isSecret    = $true
                  }
               }
               ProviderData = @{
                  serviceEndpointId = "0228e842-65a7-4c64-90f7-0f07f3aa4e10"
                  vault             = "keyVaultName"
               }
            }

            Add-VSTeamVariableGroup @testParameters

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }
      }

      Context 'Update-VSTeamVariableGroup' {
         Mock Invoke-RestMethod {
            #Write-Host $args

            $collection = Get-Content $sampleFileVSTS | ConvertFrom-Json
            return $collection.value | Where-Object {$_.id -eq 1}
         } -Verifiable

         It 'should update an exisiting Variable Group' {
            $testParameters = @{
               ProjectName              = "project"
               Id                       = 1
               Name        = "TestVariableGroup1"
               Description = "A test variable group"
               Type        = "Vsts"
               Variables   = @{
                  key1 = @{
                     value = "value"
                  }
                  key2 = @{
                     value    = ""
                     isSecret = $true
                  }
               }
            }

            Update-VSTeamVariableGroup @testParameters

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/$($testParameters.id)?api-version=$([VSTeamVersions]::VariableGroups)" -and
               $Method -eq 'Put'
            }
         }
      }
   }
}
