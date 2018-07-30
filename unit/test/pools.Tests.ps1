Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force

Import-Module $PSScriptRoot\..\..\VSTeam.psd1 -Force

InModuleScope pools {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'
   $VSTeamVersionTable.DistributedTask = '1.0-unitTest'

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
      . "$PSScriptRoot\..\..\src\teamspsdrive.ps1"

      Context 'Get-VSTeamPool with no parameters' {
         Mock Invoke-RestMethod { return [PSCustomObject]@{
               count = 1
               value = $privatePool
            }
         }

         it 'Should return all the pools' {
            Get-VSTeamPool

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/distributedtask/pools/?api-version=$($VSTeamVersionTable.DistributedTask)"
            }
         }
      }

      Context 'Get-VSTeamPool with id parameter' {
         Mock Invoke-RestMethod { return $hostedPool }

         it 'Should return all the pools' {
            Get-VSTeamPool -id '1'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/_apis/distributedtask/pools/1?api-version=$($VSTeamVersionTable.DistributedTask)"
            }
         }
      }
   }
}