Set-StrictMode -Version Latest

Describe 'VSTeamPool' {
   BeforeAll {
      Import-Module SHiPS
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTaskReleased' }

      $hostedPool = [PSCustomObject]@{
         owner     = [PSCustomObject]@{
            displayName = 'Test User'
            id          = '1'
            uniqueName  = 'test@email.com'
         }
         createdBy = [PSCustomObject]@{
            displayName = 'Test User'
            id          = '1'
            uniqueName  = 'test@email.com'
         }
         id        = [long]1
         size      = [long]1
         isHosted  = $true
         Name      = 'Hosted'
      }

      $privatePool = [PSCustomObject]@{
         owner     = [PSCustomObject]@{
            displayName = 'Test User'
            id          = '1'
            uniqueName  = 'test@email.com'
         }
         createdBy = [PSCustomObject]@{
            displayName = 'Test User'
            id          = '1'
            uniqueName  = 'test@email.com'
         }
         id        = [long]1
         size      = [long]1
         isHosted  = $false
         Name      = 'Default'
      }
   }

   Context 'Get-VSTeamPool with no parameters' {
      BeforeAll {
         Mock Invoke-RestMethod { return [PSCustomObject]@{
               count = 1
               value = $privatePool
            }
         }

         Mock Invoke-RestMethod { return $hostedPool } -ParameterFilter { $Uri -like "*101*" }
      }

      it 'with no parameters should return all the pools' {
         ## Act
         Get-VSTeamPool

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools?api-version=$(_getApiVersion DistributedTaskReleased)"
         }
      }

      it 'with id parameter should return all the pools' {
         ## Act
         Get-VSTeamPool -id 101

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/101?api-version=$(_getApiVersion DistributedTaskReleased)"
         }
      }
   }
}