Set-StrictMode -Version Latest

InModuleScope pools {
   [VSTeamVersions]::Account = 'https://dev.azure.com/test'
   [VSTeamVersions]::DistributedTask = '1.0-unitTest'

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
      id        = 1
      size      = 1
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
      id        = 1
      size      = 1
      isHosted  = $false
      Name      = 'Default'
   }

   Describe 'pools' {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*" 
      }
   
      Context 'Get-VSTeamPool with no parameters' {
         Mock Invoke-RestMethod { return [PSCustomObject]@{
               count = 1
               value = $privatePool
            }
         }

         it 'Should return all the pools' {
            Get-VSTeamPool

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/?api-version=$([VSTeamVersions]::DistributedTask)"
            }
         }
      }

      Context 'Get-VSTeamPool with id parameter' {
         Mock Invoke-RestMethod { return $hostedPool }

         it 'Should return all the pools' {
            Get-VSTeamPool -id '1'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/1?api-version=$([VSTeamVersions]::DistributedTask)"
            }
         }
      }
   }
}