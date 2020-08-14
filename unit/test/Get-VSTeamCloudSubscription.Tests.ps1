Set-StrictMode -Version Latest

Describe 'VSTeamCloudSubscription' {
   BeforeAll {
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
   
      
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())
   }
   
   Context 'Get-VSTeamCloudSubscription' {
      BeforeAll {
         Mock Invoke-RestMethod { return @{value = 'subs' } }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }
      }

      Context 'Services' {
         BeforeAll {
            Mock _getInstance { return 'https://dev.azure.com/test' }
         }

         It 'should return all AzureRM Subscriptions' {
            Get-VSTeamCloudSubscription

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/serviceendpointproxy/azurermsubscriptions?api-version=$(_getApiVersion DistributedTask)"
            }
         }
      }

      Context 'Server' {
         BeforeAll {
            Mock _useWindowsAuthenticationOnPremise { return $true }
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         }

         It 'should return all AzureRM Subscriptions' {
            Get-VSTeamCloudSubscription

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/distributedtask/serviceendpointproxy/azurermsubscriptions?api-version=$(_getApiVersion DistributedTask)"
            }
         }
      }
   }
}