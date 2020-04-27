Set-StrictMode -Version Latest

Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

Describe 'Feeds' {
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   Context 'Show-VSTeamFeed by name' {
      Mock Show-Browser

      It 'Show call start' {
         Show-VSTeamFeed -Name module

         Assert-MockCalled Show-Browser
      }
   }

   Context 'Show-VSTeamFeed by id' {
      Mock Show-Browser

      It 'Show call start' {
         Show-VSTeamFeed -Id '00000000-0000-0000-0000-000000000000'

         Assert-MockCalled Show-Browser
      }
   }
}