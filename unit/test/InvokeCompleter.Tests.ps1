Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamOption.ps1"
. "$here/../../Source/Classes/$sut"
#endregion

Describe "InvokeCompleter" {

   BeforeAll {
      $result = Get-Content "$PSScriptRoot\sampleFiles\Get-VSTeamOption.json" -Raw | ConvertFrom-Json
      $resultVsrmSubDomain = Get-Content "$PSScriptRoot\sampleFiles\Get-VSTeamOption_vsrm.json" -Raw | ConvertFrom-Json

      Mock Get-VSTeamOption { return $result.value }
      Mock Get-VSTeamOption { return $resultVsrmSubDomain.value } -ParameterFilter { $subDomain -eq 'vsrm' }
   }

   Context "Area" {
      It "it should return all areas" {
         $target = [InvokeCompleter]::new()

         $actual = $target.CompleteArgument("Invoke-VSTeamRequest", "Area", "", $null, @{ })

         $actual.count | Should Be 76
      }
   }

   Context "Sub Domain" {
      It "it should return all areas for sub domain" {
         $target = [InvokeCompleter]::new()

         $actual = $target.CompleteArgument("Invoke-VSTeamRequest", "Area", "", $null, @{ subDomain = 'vsrm' })

         $actual.count | Should Be 31
      }
   }

   Context "with area and subdomain" {      
      It "should return resources for no area with sub domain" {
         $target = [InvokeCompleter]::new()

         $actual = $target.CompleteArgument("Invoke-VSTeamRequest", "Resource", "", $null, @{ subDomain = 'vsrm' })

         $actual.count | Should Be 0
      }

      It "should return resources for area and sub domain" {
         $target = [InvokeCompleter]::new()

         $actual = $target.CompleteArgument("Invoke-VSTeamRequest", "Resource", "", $null, @{ subDomain = 'vsrm'; Area = 'Release' })

         $actual.count | Should Be 38
      }
   }
}