Set-StrictMode -Version Latest

Describe 'VSTeamVariableGroup' {
   BeforeAll {

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Set-VSTeamAPIVersion.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamVariableGroup.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      Mock _getProjects { return @() }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'VariableGroups' }
   }

   Context 'Add-VSTeamVariableGroup' {
      Context 'Services' {
         BeforeAll {
            $sampleFileVSTS = $(Get-Content "$PSScriptRoot\sampleFiles\variableGroupSamples.json" | ConvertFrom-Json)

            Mock _getInstance { return 'https://dev.azure.com/test' }

            Set-VSTeamAPIVersion -Target VSTS

            Mock Invoke-RestMethod { return $sampleFileVSTS.value[0] }
         }

         It 'should create a new AzureRM Key Vault Variable Group' {
            $testParameters = @{
               ProjectName  = "project"
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

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }

         It "should create a new var group when passing the json as the body" {
            $body = $sampleFileVSTS
            $projName = "project"
            Add-VSTeamVariableGroup -Body $body -ProjectName $projName

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/$projName/_apis/distributedtask/variablegroups?api-version=$(_getApiVersion VariableGroups)" -and
               $Method -eq 'Post'
            }
         }
      }

      Context 'Server' {
         BeforeAll {
            $sampleFile2017 = $(Get-Content "$PSScriptRoot\sampleFiles\variableGroupSamples2017.json" | ConvertFrom-Json)

            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

            Set-VSTeamAPIVersion -Target TFS2017

            Mock Invoke-RestMethod { return $sampleFile2017.value[0] }
         }

         It 'should create a new Variable Group' {
            $testParameters = @{
               ProjectName = "project"
               Name        = "TestVariableGroup2"
               Description = "A test variable group linked to an Azure KeyVault"
               Variables   = @{
                  key1 = @{
                     value = "value"
                  }
               }
            }

            Add-VSTeamVariableGroup @testParameters

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }
      }
   }
}
