Set-StrictMode -Version Latest

Describe 'VSTeamPool' {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUserEntitlement.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamPool.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _hasProjectCacheExpired { return $false }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }
   }

   Context 'Remove-VSTeamPool with parameters' {
      BeforeAll {
         Mock Invoke-RestMethod { return $null }

         Mock Invoke-RestMethod { return $hostedPool } -ParameterFilter { $Uri -like "*101*" }
      }

      it 'with ID should be called' {
         ## Act
         Remove-VSTeamPool -Id 5

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Delete'
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/$($Id)?api-version=$(_getApiVersion DistributedTask)"
         }
      }
   }
}