Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Add-VSTeamServiceEndpoint.ps1"
. "$here/../../Source/Public/Get-VSTeamServiceEndpoint.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamServiceEndpoint' {
   Context 'Update-VSTeamServiceEndpoint' {
      Mock _hasProjectCacheExpired { return $false }

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'ServiceFabricEndpoint' }

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

      It 'should update Serviceendpoint' {
         Update-VSTeamServiceEndpoint -projectName 'project' -id '23233-2342' `
            -object @{ key = 'value' }

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Put'
         }
      }
   }
}