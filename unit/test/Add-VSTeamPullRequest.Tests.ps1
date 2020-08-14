Set-StrictMode -Version Latest

Describe 'VSTeamPullRequest' {
   ## Arrange
   BeforeAll {
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

      # You have to set the version or the api-version will not be added when versions = ''
      Mock _getApiVersion { return '1.0-gitUnitTests' } -ParameterFilter { $Service -eq 'Git' }

      # Get-VSTeamProject for cache
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*https://dev.azure.com/test/_apis/projects*" -and
         $Uri -like "*api-version=$(_getApiVersion Core)*" -and
         $Uri -like "*`$top=100*" -and
         $Uri -like "*stateFilter=WellFormed*"
      }

      $result = Get-Content "$PSScriptRoot\sampleFiles\updatePullRequestResponse.json" -Raw | ConvertFrom-Json
   }

   Context 'Add-VSTeamPullRequest' {
      BeforeAll {
         Mock Invoke-RestMethod { return $result }
      }

      It 'Add-VSTeamPullRequest as Draft' {
         ## Act
         Add-VSTeamPullRequest -RepositoryId "45df2d67-e709-4557-a7f9-c6812b449277" -ProjectName "Sandbox" `
            -Title "PR Title" -Description "PR Description" `
            -SourceRefName "refs/heads/test" -TargetRefName "refs/heads/master" `
            -Draft -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'Post' -and
            $Uri -like "*repositories/45df2d67-e709-4557-a7f9-c6812b449277/*" -and
            $Uri -like "*pullrequests*" -and
            $Body -eq '{"sourceRefName": "refs/heads/test", "targetRefName": "refs/heads/master", "title": "PR Title", "description": "PR Description", "isDraft": true}'
         }
      }

      It 'Add-VSTeamPullRequest as Published' {
         ## Act
         Add-VSTeamPullRequest -RepositoryId "45df2d67-e709-4557-a7f9-c6812b449277" -ProjectName "Sandbox" `
            -Title "PR Title" -Description "PR Description" `
            -SourceRefName "refs/heads/test" -TargetRefName "refs/heads/master" `
            -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'Post' -and
            $Uri -like "*repositories/45df2d67-e709-4557-a7f9-c6812b449277/*" -and
            $Uri -like "*pullrequests*" -and
            $Body -eq '{"sourceRefName": "refs/heads/test", "targetRefName": "refs/heads/master", "title": "PR Title", "description": "PR Description", "isDraft": false}'
         }
      }

      It 'Add-VSTeamPullRequest with wrong -SourceRefName throws' {
         ## Act / Assert
         {
            Add-VSTeamPullRequest -RepositoryId "45df2d67-e709-4557-a7f9-c6812b449277" -ProjectName "Sandbox" `
               -Title "PR Title" -Description "PR Description" `
               -SourceRefName "garbage" -TargetRefName "refs/heads/master" `
               -Draft -Force
         } | Should -Throw
      }

      It 'Add-VSTeamPullRequest with wrong -TargetRefName throws' {
         ## Act / Assert
         {
            Add-VSTeamPullRequest -RepositoryId "45df2d67-e709-4557-a7f9-c6812b449277" -ProjectName "Sandbox" `
               -Title "PR Title" -Description "PR Description" `
               -SourceRefName "refs/heads/test" -TargetRefName "garbage" `
               -Draft -Force
         } | Should -Throw
      }
   }
}
