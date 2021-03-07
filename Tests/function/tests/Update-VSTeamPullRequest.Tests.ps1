Set-StrictMode -Version Latest

Describe 'VSTeamPullRequest' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamUser.ps1"

      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTest' } -ParameterFilter {
         $Service -eq 'Git' -or 
         $Service -eq 'Graph'
      }

      Mock Invoke-RestMethod { Open-SampleFile 'users.single.json' }
      Mock Invoke-RestMethod { Open-SampleFile 'updatePullRequestResponse.json' } -ParameterFilter {
         $PullRequestId -eq 18000
      }
   }

   Context 'Update-VSTeamPullRequest' {
      It 'Update-VSTeamPullRequest to Draft' {
         ## Act
         Update-VSTeamPullRequest -RepositoryId "45df2d67-e709-4557-a7f9-c6812b449277" -PullRequestId 19543 -Draft -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Scope It -ParameterFilter {
            $Method -eq 'Patch' -and
            $Uri -like "*repositories/45df2d67-e709-4557-a7f9-c6812b449277/*" -and
            $Uri -like "*pullrequests/19543*" -and
            $Body -eq '{"isDraft": true }'
         }
      }

      It 'Update-VSTeamPullRequest to Published' {
         ## Act
         Update-VSTeamPullRequest -RepositoryId "45df2d67-e709-4557-a7f9-c6812b449277" -PullRequestId 19543 -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Scope It -ParameterFilter {
            $Method -eq 'Patch' -and
            $Uri -like "*repositories/45df2d67-e709-4557-a7f9-c6812b449277/*" -and
            $Uri -like "*pullrequests/19543*" -and
            $Body -eq '{"isDraft": false }'
         }
      }

      It 'Update-VSTeamPullRequest to set status to abandoned' {
         ## Act
         Update-VSTeamPullRequest -RepositoryId "45df2d67-e709-4557-a7f9-c6812b449277" -PullRequestId 18000 -Status abandoned -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Uri -like "*repositories/45df2d67-e709-4557-a7f9-c6812b449277/*" -and
            $Uri -like "*pullrequests/18000*" -and
            $Body -eq '{"status": "abandoned"}'
         }
      }

      It 'Update-VSTeamPullRequest to set to enable auto complete' {
         ## Arrange
         $user = Get-VSTeamUser -Descriptor "aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj"

         ## Act
         Update-VSTeamPullRequest -RepositoryId "45df2d67-e709-4557-a7f9-c6812b449277" `
            -PullRequestId 19543 `
            -EnableAutoComplete `
            -AutoCompleteIdentity $user `
            -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Scope It -ParameterFilter {
            $Method -eq 'Patch' -and
            $Uri -like "*repositories/45df2d67-e709-4557-a7f9-c6812b449277/*" -and
            $Uri -like "*pullrequests/19543*" -and
            $Body -eq '{"autoCompleteSetBy": "aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj"}'
         }
      }

      It 'Update-VSTeamPullRequest to set to disable auto complete' {
         ## Act
         Update-VSTeamPullRequest -RepositoryId "45df2d67-e709-4557-a7f9-c6812b449277" -PullRequestId 19543 -DisableAutoComplete -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Scope It -ParameterFilter {
            $Method -eq 'Patch' -and
            $Uri -like "*repositories/45df2d67-e709-4557-a7f9-c6812b449277/*" -and
            $Uri -like "*pullrequests/19543*" -and
            $Body -eq '{"autoCompleteSetBy": null}'
         }
      }
   }
}