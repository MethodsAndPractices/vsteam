Set-StrictMode -Version Latest

Describe 'VSTeamFeed' {
   BeforeAll {
      Import-Module SHiPS
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
   
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
   
      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamFeed.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())
   }
   
   Context 'Get-VSTeamFeed' {
      BeforeAll {
         ## Arrange
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Packaging' }
         $results = Get-Content "$PSScriptRoot\sampleFiles\feeds.json" -Raw | ConvertFrom-Json

         Mock Invoke-RestMethod { return $results }
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock Invoke-RestMethod { return $results.value[0] } -ParameterFilter { $Uri -like "*00000000-0000-0000-0000-000000000000*" }
      }

      it 'with no parameters should return all the Feeds' {
         ## Act
         Get-VSTeamFeed

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds?api-version=$(_getApiVersion packaging)"
         }
      }

      it 'by id should return one feed' {
         ## Act
         Get-VSTeamFeed -id '00000000-0000-0000-0000-000000000000'

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://feeds.dev.azure.com/test/_apis/packaging/feeds/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion packaging)"
         }
      }
   }
}