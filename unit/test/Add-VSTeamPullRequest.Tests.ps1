Set-StrictMode -Version Latest
$env:Testing=$true
# Loading the code from source files will break if functionality moves from one file to another, instead
# the InModuleScope command allows you to perform white-box unit testing on the
# internal \(non-exported\) code of a Script Module, ensuring the module is loaded.

InModuleScope VSTeam {

Describe 'VSTeamPullRequest' {


   # You have to set the version or the api-version will not be added when versions = ''
   Mock _getApiVersion { return '1.0-gitUnitTests' } -ParameterFilter { $Service -eq 'Git' }

   $result = Get-Content "$PSScriptRoot\sampleFiles\updatePullRequestResponse.json" -Raw | ConvertFrom-Json

   Context 'Add-VSTeamPullRequest' {
      Mock Invoke-RestMethod { return $result }

      It 'Add-VSTeamPullRequest as Draft' {
         ## Act
         Add-VSTeamPullRequest -RepositoryId "45df2d67-e709-4557-a7f9-c6812b449277" -ProjectName "Sandbox" `
            -Title "PR Title" -Description "PR Description" `
            -SourceRefName "refs/heads/test" -TargetRefName "refs/heads/master" `
            -Draft -Force

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
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
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
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
         } | Should Throw
      }

            It 'Add-VSTeamPullRequest with wrong -SourceRefName throws' {
               {
                  Add-VSTeamPullRequest -RepositoryId "45df2d67-e709-4557-a7f9-c6812b449277" -ProjectName "Sandbox" `
                  -Title "PR Title" -Description "PR Description" `
                  -SourceRefName "garbage" -TargetRefName "refs/heads/master" `
                  -Draft -Force
               } | Should Throw
            }

            It 'Add-VSTeamPullRequest with wrong -TargetRefName throws' {
               {
                  Add-VSTeamPullRequest -RepositoryId "45df2d67-e709-4557-a7f9-c6812b449277" -ProjectName "Sandbox" `
                  -Title "PR Title" -Description "PR Description" `
                  -SourceRefName "refs/heads/test" -TargetRefName "garbage" `
                  -Draft -Force
               } | Should Throw
            }
        }
    }
}