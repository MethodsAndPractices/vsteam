Set-StrictMode -Version Latest

Describe 'VSTeamWiki' {
   BeforeAll {
      $FakeOrg = 'myOrg'

      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"
      . "$baseFolder/Source/Public/Remove-VSTeamGitRepository.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamWiki.ps1"

      Mock _getInstance { return "https://dev.azure.com/$($FakeOrg)" }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Wiki' }
      Mock Get-VSTeamProject { return Open-SampleFile 'Get-VSTeamProject.json' }
   }

   Context 'Remove-VSTeamWiki' {
      BeforeAll {
         $FakeProjectName = 'test'
         $FakeCodeWikiId = '00000000-0000-0000-0000-000000000000'
         $FakeCodeWikiName = 'myWiki1'
         $FakeProjectWikiId = '00000000-0000-0000-0000-000000000001'
         $FakeProjectWikiName = 'myWiki2'

         # response when using wiki endpoint - deleting code wikis
         Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamWiki.json' -Index 0 } -ParameterFilter { # when wiki is deleted, it returns object as when its created
            $Method -eq 'DELETE' -and
            $Uri -like "*wiki/wikis/$($FakeCodeWikiId)*"
         }
         # response when using git endpoint - deleting project wikis
         Mock Remove-VSTeamGitRepository { return $null } -ParameterFilter {
            $Id -eq $FakeProjectWikiId
         }
         Mock Get-VSTeamWiki { Open-SampleFile 'Get-VSTeamWiki.json' -ReturnValue } # called with no parameters, return all wikis
         Mock Get-VSTeamWiki { Open-SampleFile 'Get-VSTeamWiki.json' -index 0 } -ParameterFilter { # pass project and CODE wiki name returns specific wiki
            $Name -eq $FakeCodeWikiName -and
            $ProjectName -eq $FakeProjectName
         }
         Mock Get-VSTeamWiki { Open-SampleFile 'Get-VSTeamWiki.json' -index 1 } -ParameterFilter { # pass project and PROJECT wiki name returns specific wiki
            $Name -eq $FakeProjectWikiName -and
            $ProjectName -eq $FakeProjectName
         }
      }

      It 'code wiki, by name, should unpublish wiki' {
         ## Act
         Remove-VSTeamWiki -ProjectName $FakeProjectName -WikiName $FakeCodeWikiName

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/$($FakeOrg)/_apis/wiki/wikis/$($FakeCodeWikiId)?api-version=$(_getApiVersion Wiki)" -and
            $Method -eq 'DELETE'
         }
      }

      It 'code wiki, by id, should unpublish wiki' {
         ## Act
         Remove-VSTeamWiki -WikiId $FakeCodeWikiId

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/$($FakeOrg)/_apis/wiki/wikis/$($FakeCodeWikiId)?api-version=$(_getApiVersion Wiki)" -and
            $Method -eq 'DELETE'
         }
      }

      It 'project wiki, by name, should unpublish wiki' {
         ## Act
         Remove-VSTeamWiki -ProjectName $FakeProjectName -WikiName $FakeProjectWikiName

         ## Assert
         Should -Invoke Remove-VSTeamGitRepository -Exactly -Times 1 -Scope It -ParameterFilter {
            $Id -eq $FakeProjectWikiId
         }
      }

      It 'project wiki, by id, should unpublish wiki' {
         ## Act
         Remove-VSTeamWiki -WikiId $FakeProjectWikiId

         ## Assert
         Should -Invoke Remove-VSTeamGitRepository -Exactly -Times 1 -Scope It -ParameterFilter {
            $Id -eq $FakeProjectWikiId
         }
      }

      It 'invalid wiki, should trigger exception' {
         ## Act
         { Remove-VSTeamWiki -WikiId '00000000-0000-0000-0000-000000000002' } |  # WikiId that does not exist in the Sample File

         ## Assert
         Should -Throw "Wiki not found in project provided"
      }
   }
}