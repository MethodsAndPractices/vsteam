Set-StrictMode -Version Latest

Describe 'VSTeamPolicy' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamPolicy.ps1"
      
      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Invoke-RestMethod
      Mock Invoke-RestMethod { throw 'Error' } -ParameterFilter { $Uri -like "*boom*" }
      Mock Get-VSTeamPolicy { return @{ type = @{ id = 'babcf51f-d853-43a2-9b05-4a64ca577be0' } } }
   }

   Context 'Update-VSTeamPolicy' {
      It 'with type should add the policy' {
         ## Act
         Update-VSTeamPolicy -ProjectName Demo `
            -id 1 `
            -type babcf51f-d853-43a2-9b05-4a64ca577be0 `
            -enabled `
            -blocking `
            -settings @{
            MinimumApproverCount = 1
            scope                = @(
               @{
                  refName      = 'refs/heads/release'
                  matchKind    = 'Exact'
                  repositoryId = '20000000-0000-0000-0000-0000000000002'
               })
         }

         ## Assert
         # With PowerShell core the order of the boty string is not the
         # same from run to run!  So instead of testing the entire string
         # matches I have to search for the portions I expect but can't
         # assume the order.
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'Put' -and
            $Uri -eq "https://dev.azure.com/test/Demo/_apis/policy/configurations/1?api-version=$(_getApiVersion Policy)" -and
            $Body -like '*"isBlocking":true*' -and
            $Body -like '*"isEnabled":true*' -and
            $Body -like '*"type":*' -and
            $Body -like '*"id":"babcf51f-d853-43a2-9b05-4a64ca577be0"*' -and
            $Body -like '*"settings":*' -and
            $Body -like '*"scope":*' -and
            $Body -like '*"repositoryId":"20000000-0000-0000-0000-0000000000002"*' -and
            $Body -like '*"matchKind":"Exact"*' -and
            $Body -like '*"refName":"refs/heads/release"*' -and
            $Body -like '*"MinimumApproverCount":1*'
         }
      }

      It 'without type should add the policy' {
         ## Act
         Update-VSTeamPolicy -ProjectName Demo `
            -id 1 `
            -enabled `
            -blocking `
            -settings @{
            MinimumApproverCount = 1
            scope                = @(
               @{
                  refName      = 'refs/heads/release'
                  matchKind    = 'Exact'
                  repositoryId = '20000000-0000-0000-0000-0000000000002'
               })
         }

         ## Assert
         # With PowerShell core the order of the boty string is not the
         # same from run to run!  So instead of testing the entire string
         # matches I have to search for the portions I expect but can't
         # assume the order.
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq 'Put' -and
            $Uri -eq "https://dev.azure.com/test/Demo/_apis/policy/configurations/1?api-version=$(_getApiVersion Policy)" -and
            $Body -like '*"isBlocking":true*' -and
            $Body -like '*"isEnabled":true*' -and
            $Body -like '*"type":*' -and
            $Body -like '*"id":"babcf51f-d853-43a2-9b05-4a64ca577be0"*' -and
            $Body -like '*"settings":*' -and
            $Body -like '*"scope":*' -and
            $Body -like '*"repositoryId":"20000000-0000-0000-0000-0000000000002"*' -and
            $Body -like '*"matchKind":"Exact"*' -and
            $Body -like '*"refName":"refs/heads/release"*' -and
            $Body -like '*"MinimumApproverCount":1*'
         }
      }

      It 'should throw' {
         ## Act / Assert
         { Update-VSTeamPolicy -ProjectName boom `
               -id 1 `
               -type babcf51f-d853-43a2-9b05-4a64ca577be0 `
               -enabled `
               -blocking `
               -settings @{
               MinimumApproverCount = 1
               scope                = @(
                  @{
                     refName      = 'refs/heads/release'
                     matchKind    = 'Exact'
                     repositoryId = '20000000-0000-0000-0000-0000000000002'
                  })
            }
         } | Should -Throw
      }
   }
}