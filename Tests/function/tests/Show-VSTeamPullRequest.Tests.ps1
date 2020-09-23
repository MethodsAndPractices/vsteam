Set-StrictMode -Version Latest

Describe 'VSTeamPullRequest' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamPullRequest.ps1"

      # You have to manually load the type file so the property reviewStatus
      # can be tested.
      Update-TypeData -AppendPath "$baseFolder/Source/types/vsteam_lib.PullRequest.ps1xml" -ErrorAction Ignore

      ## Arrange
      Mock Show-Browser
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock Show-Browser { throw } -ParameterFilter { $id -eq 999999 }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamPullRequest-Id_17.json' }
      Mock _getApiVersion { return '1.0-unitTest' } -ParameterFilter { $Service -eq 'Git' }
   }

   Context 'Show-VSTeamPullRequest' {
      It 'by Id' {
         ## Act
         Show-VSTeamPullRequest -Id 17

         ## Assert
         Should -Invoke Show-Browser -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -eq "https://dev.azure.com/test/PeopleTracker/_git/PeopleTracker/pullrequest/17"
         }
      }

      It 'with invalid ID' {
         ## Act / Assert
         { Show-VSTeamPullRequest -Id 999999 } | Should -Throw
      }
   }
}