Set-StrictMode -Version Latest

Describe 'VSTeamPolicy' {
   ## Arrange
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Invoke-RestMethod
      Mock Invoke-RestMethod { throw 'Error' } -ParameterFilter { $Uri -like "*boom*" }

      Mock _getApiVersion { return '1.0-gitUnitTests' } -ParameterFilter { $Service -eq 'Policy' }
   }

   Context 'Add-VSTeamPolicy' {
      It 'should add the policy' {
         ## Act
         Add-VSTeamPolicy -ProjectName Demo `
            -type babcf51f-d853-43a2-9b05-4a64ca577be0 `
            -enabled `
            -blocking `
            -settings @{
            MinimumApproverCount = 1
            scope                = @(
               @{
                  refName      = 'refs/heads/trunk'
                  matchKind    = 'Exact'
                  repositoryId = '10000000-0000-0000-0000-0000000000001'
               })
         }

         ## Assert
         # With PowerShell core the order of the boty string is not the
         # same from run to run!  So instead of testing the entire string
         # matches I have to search for the portions I expect but can't
         # assume the order.
         # The general string should look like this:
         # '{"isBlocking":true,"isEnabled":true,"type":{"id":"babcf51f-d853-43a2-9b05-4a64ca577be0"},"settings":{"scope":[{"repositoryId":"10000000-0000-0000-0000-0000000000001","matchKind":"Exact","refName":"refs/heads/trunk"}],"MinimumApproverCount":1}}'
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'Post' -and
            $Uri -eq "https://dev.azure.com/test/Demo/_apis/policy/configurations?api-version=$(_getApiVersion Policy)" -and
            $Body -like '*"isBlocking":true*' -and
            $Body -like '*"isEnabled":true*' -and
            $Body -like '*"type":{"id":"babcf51f-d853-43a2-9b05-4a64ca577be0"}*' -and
            $Body -like '*"MinimumApproverCount":1*' -and
            $Body -like '*"settings":*' -and
            $Body -like '*"scope":*' -and
            $Body -like '*"repositoryId":"10000000-0000-0000-0000-0000000000001"*' -and
            $Body -like '*"matchKind":"Exact"*' -and
            $Body -like '*"refName":"refs/heads/trunk"*'
         }
      }

      It 'should throw' {
         ## Act / Assert
         { Add-VSTeamPolicy -ProjectName boom `
               -type babcf51f-d853-43a2-9b05-4a64ca577be0 `
               -enabled `
               -blocking `
               -settings @{
               MinimumApproverCount = 1
               scope                = @(
                  @{
                     refName      = 'refs/heads/trunk'
                     matchKind    = 'Exact'
                     repositoryId = '10000000-0000-0000-0000-0000000000001'
                  })
            }
         } | Should -Throw
      }
   }
}
