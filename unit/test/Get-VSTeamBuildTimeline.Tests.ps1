Set-StrictMode -Version Latest

Describe 'VSTeamBuildTimeline' {
   BeforeAll {
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
   
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   
      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())
      
      ## Arrnage
      [VSTeamVersions]::Build = '1.0-unitTest'
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
      $buildTimeline = Get-Content "$PSScriptRoot\sampleFiles\buildTimeline.json" -Raw | ConvertFrom-Json
      $buildTimelineEmptyRecords = Get-Content "$PSScriptRoot\sampleFiles\buildTimelineEmptyRecords.json" -Raw | ConvertFrom-Json
   }

   Context 'Get-VSTeamBuildTimeline by ID' {
      BeforeAll {
         Mock Invoke-RestMethod { return $buildTimeline }
      }

      It 'should get timeline with multiple build IDs' {
         Get-VSTeamBuildTimeline -BuildID @(1, 2) -Id 00000000-0000-0000-0000-000000000000 -ProjectName "MyProject"

         Should -Invoke Invoke-RestMethod -Scope It -Times 2 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/MyProject/_apis/build/*" -and
            ($Uri -like "*builds/1/*" -or $Uri -like "*builds/2/*")
            $Uri -like "*timeline/00000000-0000-0000-0000-000000000000*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Build)*"
         }
      }

      It 'should get timeline with changeId and PlanId' {
         Get-VSTeamBuildTimeline -BuildID 1 -Id 00000000-0000-0000-0000-000000000000 -ProjectName "MyProject" -ChangeId 4 -PlanId 00000000-0000-0000-0000-000000000000

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/MyProject/_apis/build/builds/1/*" -and
            $Uri -like "*timeline/00000000-0000-0000-0000-000000000000*" -and
            $Uri -like "*planId=00000000-0000-0000-0000-000000000000*" -and
            $Uri -like "*changeId=4*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Build)*"
         }
      }

      It 'should get timeline without changeId' {
         Get-VSTeamBuildTimeline -BuildID 1 -Id 00000000-0000-0000-0000-000000000000 -ProjectName "MyProject" -PlanId 00000000-0000-0000-0000-000000000000

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/MyProject/_apis/build/builds/1/*" -and
            $Uri -like "*timeline/00000000-0000-0000-0000-000000000000*" -and
            $Uri -like "*planId=00000000-0000-0000-0000-000000000000*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Build)*"
         }
      }

      It 'should get timeline without planId' {
         Get-VSTeamBuildTimeline -BuildID 1 -Id 00000000-0000-0000-0000-000000000000 -ProjectName "MyProject" -ChangeId 4

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/MyProject/_apis/build/builds/1/*" -and
            $Uri -like "*timeline/00000000-0000-0000-0000-000000000000*" -and
            $Uri -like "*changeId=4*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Build)*"
         }
      }

      It 'should get timeline without planId and changeID' {
         Get-VSTeamBuildTimeline -BuildID 1 -Id 00000000-0000-0000-0000-000000000000 -ProjectName "MyProject"

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/MyProject/_apis/build/builds/1/*" -and
            $Uri -like "*timeline/00000000-0000-0000-0000-000000000000*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Build)*"
         }
      }

      It 'should get timeline without records and no exception' {
         Mock Invoke-RestMethod { return $buildTimelineEmptyRecords }

         $null = Get-VSTeamBuildTimeline -BuildID 1 -Id 00000000-0000-0000-0000-000000000000 -ProjectName "MyProject" -ChangeId 4 -PlanId 00000000-0000-0000-0000-000000000000

         { Get-VSTeamBuildTimeline -BuildID 1 -ProjectName "MyProject" } | Should -Not -Throw
      }
   }
}