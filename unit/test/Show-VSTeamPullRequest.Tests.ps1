Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Classes/VSTeamProcess.ps1"
. "$here/../../Source/Classes/VSTeamProcessCache.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamPullRequest.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamPullRequest' {
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

   Context 'Show-VSTeamPullRequest' {
      It 'Show-VSTeamPullRequest by Id' {
         Mock Invoke-RestMethod { return $singleResult }
         Mock Show-Browser

         Show-VSTeamPullRequest -Id 1

         Assert-MockCalled Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq "https://dev.azure.com/test/testproject/_git/testreponame/pullrequest/1"
         }
      }

      It 'Show-VSTeamPullRequest with invalid ID' {
         Mock Invoke-RestMethod { return $singleResult }
         Mock Show-Browser { throw }

         { Show-VSTeamPullRequest -Id 999999 } | Should throw
      }
   }
}