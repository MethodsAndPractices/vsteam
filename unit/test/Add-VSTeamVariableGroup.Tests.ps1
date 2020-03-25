Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Set-VSTeamAPIVersion.ps1"
. "$here/../../Source/Public/Get-VSTeamVariableGroup.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamVariableGroup' {
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/project*" }

   Context 'Add-VSTeamVariableGroup' {
      Context 'Services' {
         . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

         [VSTeamVersions]::VariableGroups = '5.0-preview.1'

         $sampleFileVSTS = $(Get-Content "$PSScriptRoot\sampleFiles\variableGroupSamples.json" | ConvertFrom-Json)

         Mock _getInstance { return 'https://dev.azure.com/test' }

         BeforeAll {
            Set-VSTeamAPIVersion -Target VSTS
         }

         Mock Invoke-RestMethod { return $sampleFileVSTS.value[0] }

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

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }

         It "should create a new var group when passing the json as the body" {
            $body = $sampleFileVSTS
            $projName = "project"
            Add-VSTeamVariableGroup -Body $body -ProjectName $projName

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/$projName/_apis/distributedtask/variablegroups?api-version=$([VSTeamVersions]::VariableGroups)" -and
               $Method -eq 'Post'
            }
         }
      }

      Context 'Server' {
         . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

         [VSTeamVersions]::VariableGroups = '3.2-preview.1'

         $sampleFile2017 = $(Get-Content "$PSScriptRoot\sampleFiles\variableGroupSamples2017.json" | ConvertFrom-Json)

         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

         BeforeAll {
            Set-VSTeamAPIVersion -Target TFS2017
         }

         Mock Invoke-RestMethod { return $sampleFile2017.value[0] }

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

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Post' }
         }
      }
   }
}