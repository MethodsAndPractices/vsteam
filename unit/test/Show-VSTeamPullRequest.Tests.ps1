Set-StrictMode -Version Latest

Describe 'VSTeamPullRequest' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProcess.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProcessCache.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamPullRequest.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTest' } -ParameterFilter { $Service -eq 'Git' }

      $singleResult = @{
         pullRequestId  = 1
         repositoryName = "testreponame"
         repository     = @{
            project = @{
               name = "testproject"
            }
         }
         reviewers      = @{
            vote = 0
         }
      }

      Mock Invoke-RestMethod { return $singleResult }

      Mock Show-Browser
   }

   Context 'Show-VSTeamPullRequest' {
      It 'by Id' {
         Show-VSTeamPullRequest -Id 1

         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq "https://dev.azure.com/test/testproject/_git/testreponame/pullrequest/1"
         }
      }

      It 'with invalid ID' {
         Mock Show-Browser { throw }

         { Show-VSTeamPullRequest -Id 999999 } | Should -Throw
      }
   }
}