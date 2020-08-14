Set-StrictMode -Version Latest

Describe 'VSTeamFeed' {
   BeforeAll {
      Import-Module SHiPS
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())
      
      Mock _getApiVersion { return '1.0-unitTests' }
      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Invoke-RestMethod
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