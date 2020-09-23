Set-StrictMode -Version Latest

Describe 'VSTeamBuildTimeline' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrnage
      [vsteam_lib.Versions]::Build = '1.0-unitTest'
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
   }

   Context 'Get-VSTeamBuildTimeline by ID' {
      BeforeAll {
         Mock Invoke-RestMethod { Open-SampleFile 'buildTimeline.json' }
      }

      It 'should get timeline with multiple build IDs' {
         Get-VSTeamBuildTimeline -Id @(1, 2) `
            -TimelineId 00000000-0000-0000-0000-000000000000 `
            -ProjectName "MyProject"

         Should -Invoke Invoke-RestMethod -Scope It -Times 2 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/MyProject/_apis/build/*" -and
            ($Uri -like "*builds/1/*" -or $Uri -like "*builds/2/*")
            $Uri -like "*timeline/00000000-0000-0000-0000-000000000000*" -and
            $Uri -like "*api-version=$([vsteam_lib.Versions]::Build)*"
         }
      }

      It 'should get timeline with changeId and PlanId' {
         Get-VSTeamBuildTimeline -Id 1 `
            -TimelineId 00000000-0000-0000-0000-000000000000 `
            -ProjectName "MyProject" `
            -ChangeId 4 `
            -PlanId 00000000-0000-0000-0000-000000000000

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/MyProject/_apis/build/builds/1/*" -and
            $Uri -like "*timeline/00000000-0000-0000-0000-000000000000*" -and
            $Uri -like "*planId=00000000-0000-0000-0000-000000000000*" -and
            $Uri -like "*changeId=4*" -and
            $Uri -like "*api-version=$([vsteam_lib.Versions]::Build)*"
         }
      }

      It 'should get timeline without changeId' {
         Get-VSTeamBuildTimeline -Id 1 `
            -TimelineId 00000000-0000-0000-0000-000000000000 `
            -ProjectName "MyProject" `
            -PlanId 00000000-0000-0000-0000-000000000000

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/MyProject/_apis/build/builds/1/*" -and
            $Uri -like "*timeline/00000000-0000-0000-0000-000000000000*" -and
            $Uri -like "*planId=00000000-0000-0000-0000-000000000000*" -and
            $Uri -like "*api-version=$([vsteam_lib.Versions]::Build)*"
         }
      }

      It 'should get timeline without planId' {
         Get-VSTeamBuildTimeline -Id 1 `
            -TimelineId 00000000-0000-0000-0000-000000000000 `
            -ProjectName "MyProject" `
            -ChangeId 4

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/MyProject/_apis/build/builds/1/*" -and
            $Uri -like "*timeline/00000000-0000-0000-0000-000000000000*" -and
            $Uri -like "*changeId=4*" -and
            $Uri -like "*api-version=$([vsteam_lib.Versions]::Build)*"
         }
      }

      It 'should get timeline without planId and changeID' {
         Get-VSTeamBuildTimeline -Id 1 `
            -TimelineId 00000000-0000-0000-0000-000000000000 `
            -ProjectName "MyProject"

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/MyProject/_apis/build/builds/1/*" -and
            $Uri -like "*timeline/00000000-0000-0000-0000-000000000000*" -and
            $Uri -like "*api-version=$([vsteam_lib.Versions]::Build)*"
         }
      }

      It 'should get timeline without records and no exception' {
         Mock Invoke-RestMethod { Open-SampleFile 'buildTimelineEmptyRecords.json' }

         $null = Get-VSTeamBuildTimeline -Id 1 `
            -TimelineId 00000000-0000-0000-0000-000000000000 `
            -ProjectName "MyProject" `
            -ChangeId 4 `
            -PlanId 00000000-0000-0000-0000-000000000000

         { Get-VSTeamBuildTimeline -Id 1 `
               -ProjectName "MyProject" } | Should -Not -Throw
      }
   }
}