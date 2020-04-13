Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamUser.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamUser.ps1"
. "$here/../../Source/Public/Set-VSTeamAPIVersion.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'Pull Requests' {
   Mock _getInstance { return 'https://dev.azure.com/test' }

   # You have to set the version or the api-version will not be added when versions = ''
   Mock _getApiVersion { return '1.0-unitTest' } -ParameterFilter { $Service -eq 'Git' -or $Service -eq 'Graph' }

   $result = Get-Content "$PSScriptRoot\sampleFiles\updatePullRequestResponse.json" -Raw | ConvertFrom-Json
   $userSingleResult = Get-Content "$PSScriptRoot\sampleFiles\users.single.json" -Raw | ConvertFrom-Json

   Context 'Update-VSTeamPullRequest' {

      It 'Update-VSTeamPullRequest to Draft' {
         Mock Invoke-RestMethod { return $result }

         Update-VSTeamPullRequest -RepositoryId "45df2d67-e709-4557-a7f9-c6812b449277" -PullRequestId 19543 -Draft -Force

         Assert-MockCalled Invoke-RestMethod -Scope It -ParameterFilter {
            $Method -eq 'Patch' -and
            $Uri -like "*repositories/45df2d67-e709-4557-a7f9-c6812b449277/*" -and
            $Uri -like "*pullrequests/19543*" -and
            $Body -eq '{"isDraft": true }'
         }
      }

      It 'Update-VSTeamPullRequest to Published' {
         Mock Invoke-RestMethod { return $result }

         Update-VSTeamPullRequest -RepositoryId "45df2d67-e709-4557-a7f9-c6812b449277" -PullRequestId 19543 -Force

         Assert-MockCalled Invoke-RestMethod -Scope It -ParameterFilter {
            $Method -eq 'Patch' -and
            $Uri -like "*repositories/45df2d67-e709-4557-a7f9-c6812b449277/*" -and
            $Uri -like "*pullrequests/19543*" -and
            $Body -eq '{"isDraft": false }'
         }
      }

      It 'Update-VSTeamPullRequest to set status to abandoned' {
         Mock Invoke-RestMethod { return $result }

         Update-VSTeamPullRequest -RepositoryId "45df2d67-e709-4557-a7f9-c6812b449277" -PullRequestId 19543 -Status abandoned -Force

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Uri -like "*repositories/45df2d67-e709-4557-a7f9-c6812b449277/*" -and
            $Uri -like "*pullrequests/19543*" -and
            $Body -eq '{"status": "abandoned"}'
         }
      }

      It 'Update-VSTeamPullRequest to set to enable auto complete' {
         Mock Invoke-RestMethod { return $userSingleResult }

         $user = Get-VSTeamUser -Descriptor "aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj"

         Mock Invoke-RestMethod { return $result }
         Update-VSTeamPullRequest -RepositoryId "45df2d67-e709-4557-a7f9-c6812b449277" -PullRequestId 19543 -EnableAutoComplete -AutoCompleteIdentity $user -Force

         Assert-MockCalled Invoke-RestMethod -Scope It -ParameterFilter {
            $Method -eq 'Patch' -and
            $Uri -like "*repositories/45df2d67-e709-4557-a7f9-c6812b449277/*" -and
            $Uri -like "*pullrequests/19543*" -and
            $Body -eq '{"autoCompleteSetBy": "aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj"}'
         }
      }

      It 'Update-VSTeamPullRequest to set to disable auto complete' {
         Mock Invoke-RestMethod { return $result }
         Update-VSTeamPullRequest -RepositoryId "45df2d67-e709-4557-a7f9-c6812b449277" -PullRequestId 19543 -DisableAutoComplete -Force

         Assert-MockCalled Invoke-RestMethod -Scope It -ParameterFilter {
            $Method -eq 'Patch' -and
            $Uri -like "*repositories/45df2d67-e709-4557-a7f9-c6812b449277/*" -and
            $Uri -like "*pullrequests/19543*" -and
            $Body -eq '{"autoCompleteSetBy": null}'
         }
      }
   }
}