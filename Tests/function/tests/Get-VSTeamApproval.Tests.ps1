Set-StrictMode -Version Latest

Describe 'VSTeamApproval' -Tag 'unit', 'approvals' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock Invoke-RestMethod { Open-SampleFile 'Get-VSTeamApproval.json' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Release' }
   }

   Context 'Get-VSTeamApproval' {
      Context 'Services' {
         It 'should return approvals' {
            # Act
            Get-VSTeamApproval -ProjectName TestProject

            # Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It `
               -ParameterFilter {
               $Uri -eq "https://vsrm.dev.azure.com/test/TestProject/_apis/release/approvals?api-version=$(_getApiVersion Release)"
            }
         }

         It 'should pass exception to _handleException' {
            # Arrange
            Mock _handleException -Verifiable
            Mock Invoke-RestMethod { throw 'error' } -ParameterFilter { $Uri -like "*boom*" }

            # Act
            Get-VSTeamApproval -ProjectName "boom"

            # Assert
            Should -InvokeVerifiable
         }

         It 'should return approvals only for value passed into AssignedToFilter with AssignedToFilter' {
            # Act
            Get-VSTeamApproval -projectName project -AssignedToFilter 'Test User'

            # Assert
            # With PowerShell core the order of the query string is not the
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It `
               -ParameterFilter {
               $Uri -like "*https://vsrm.dev.azure.com/test/project/_apis/release/approvals*" -and
               $Uri -like "*api-version=$(_getApiVersion Release)*" -and
               $Uri -like "*assignedtoFilter=Test User*" -and
               $Uri -like "*includeMyGroupApprovals=true*"
            }
         }
      }

      Context 'Server' {
         BeforeAll {
            ## Arrange
            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         }

         It 'should return approvals' {
            ## Act
            Get-VSTeamApproval -projectName project `
               -ReleaseId 1 `
               -AssignedToFilter 'Test User' `
               -StatusFilter Pending

            ## Assert
            # With PowerShell core the order of the query string is not the
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It `
               -ParameterFilter {
               $Uri -like "*http://localhost:8080/tfs/defaultcollection/project/_apis/release/approvals*" -and
               $Uri -like "*api-version=$(_getApiVersion Release)*" -and
               $Uri -like "*statusFilter=Pending*" -and
               $Uri -like "*assignedtoFilter=Test User*" -and
               $Uri -like "*includeMyGroupApprovals=true*" -and
               $Uri -like "*releaseIdsFilter=1*"
            }
         }
      }
   }
}