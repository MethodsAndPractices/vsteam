Set-StrictMode -Version Latest

Describe 'VSTeamFeed' {
   BeforeAll {
      Import-Module SHiPS
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
      
      Mock _getApiVersion { return '1.0-unitTests' }
      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Invoke-RestMethod
      Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }
   }

   Context 'Remove-VSTeamFeed' {
      It 'should delete feed' {
         Remove-VSTeamFeed -id '00000000-0000-0000-0000-000000000000' -Force

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Delete' -and
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Packaging)"
         }
      }
   }
}