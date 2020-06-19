Set-StrictMode -Version Latest

Describe 'VSTeamServiceEndpoint' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Add-VSTeamServiceEndpoint.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamServiceEndpoint.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context 'Update-VSTeamServiceEndpoint' {
      BeforeAll {
         Mock _hasProjectCacheExpired { return $false }

         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'ServiceEndpoints' }

         Mock Write-Progress
         Mock Invoke-RestMethod { return @{id = '23233-2342' } } -ParameterFilter { $Method -eq 'Get' }
         Mock Invoke-RestMethod { return @{id = '23233-2342' } } -ParameterFilter { $Method -eq 'Put' }
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
      }

      It 'should update Serviceendpoint' {
         Update-VSTeamServiceEndpoint -projectName 'project' -id '23233-2342' `
            -object @{ key = 'value' }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Put'
         }
      }
   }
}