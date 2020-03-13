Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

Describe 'Get-VSTeamInfo' {
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   . "$PSScriptRoot\mocks\mockProjectDynamicParamMandatoryFalse.ps1"

   Context 'Get-VSTeamInfo' {
      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*:projectName")
      }
         
      It 'should return account and default project' {
         [VSTeamVersions]::Account = "mydemos"
         $Global:PSDefaultParameterValues['*:projectName'] = 'TestProject'

         $info = Get-VSTeamInfo

         $info.Account | Should Be "mydemos"
         $info.DefaultProject | Should Be "TestProject"
      }
   }
}