Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamDirectory.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Classes/VSTeamUserEntitlement.ps1"
. "$here/../../Source/Classes/VSTeamPool.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamPool' {
   ## Arrange
   Mock _getInstance { return 'https://dev.azure.com/test' }
   Mock _hasProjectCacheExpired { return $false }
   Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }


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

      Mock Invoke-RestMethod { return $hostedPool } -ParameterFilter { $Uri -like "*101*" }

      it 'with no parameters should return all the pools' {
         ## Act
         Get-VSTeamPool

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      it 'with id parameter should return all the pools' {
         ## Act
         Get-VSTeamPool -id 101

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/101?api-version=$(_getApiVersion DistributedTask)"
         }
      }
   }
}