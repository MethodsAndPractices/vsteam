Set-StrictMode -Version Latest

Describe 'VSTeamVariableGroup' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Set-VSTeamAPIVersion.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamVariableGroup.ps1"
      
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/project*" }
   }

   Context 'Update-VSTeamVariableGroup' {
      Context 'Services' {
         BeforeAll {
            $sampleFileVSTS = Open-SampleFile 'variableGroupSamples.json'

            Mock _getApiVersion { return 'VSTS' }
            Mock _getApiVersion { return '5.0-preview.1-unitTests' } -ParameterFilter { $Service -eq 'VariableGroups' }

            Mock _getInstance { return 'https://dev.azure.com/test' }

            Mock Invoke-RestMethod { return $sampleFileVSTS.value[0] }
         }

         It 'should update an exisiting Variable Group' {
            $testParameters = @{
               ProjectName  = "project"
               Id           = 1
               Name         = "TestVariableGroup1"
               Description  = "A test variable group"
               Type         = "Vsts"
               Variables    = @{
                  key1 = @{
                     value = "value"
                  }
                  key2 = @{
                     value    = ""
                     isSecret = $true
                  }
               }
               ProviderData = @{
                  serviceEndpointId = "AzureRMServiceEndpointGuid"
                  vault             = "name_of_existing_key_vault"
               }
            }

            Update-VSTeamVariableGroup @testParameters

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/$($testParameters.id)?api-version=$(_getApiVersion VariableGroups)" -and
               $Method -eq 'Put'
            }
         }

         It "should update an existing var group when passing the json as the body" {
            $body = $sampleFileVSTS
            $projName = "project"
            $id = "1"
            Update-VSTeamVariableGroup -Body $body -ProjectName $projName -Id $id

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/$projName/_apis/distributedtask/variablegroups/$($id)?api-version=$(_getApiVersion VariableGroups)" -and
               $Method -eq 'Put'
            }
         }
      }

      Context 'Server' {
         BeforeAll {
            $sampleFile2017 = Open-SampleFile 'variableGroupSamples2017.json'

            Mock _getApiVersion { return 'TFS2017' }
            Mock _getApiVersion { return '3.2-preview.1-unitTests' }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

            Mock Invoke-RestMethod { return $sampleFile2017.value[0] }
         }

         It 'should update an exisiting Variable Group' {
            $testParameters = @{
               ProjectName = "project"
               id          = 1
               Name        = "TestVariableGroup1"
               Description = "A test variable group"
               Type        = "AzureKeyVault"
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

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/distributedtask/variablegroups/$($testParameters.id)?api-version=$(_getApiVersion VariableGroups)" -and
               $Method -eq 'Put'
            }
         }
      }
   }
}