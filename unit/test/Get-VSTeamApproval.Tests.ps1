Set-StrictMode -Version Latest

BeforeAll {

   $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

   . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
   . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
   . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
   . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
   . "$PSScriptRoot/../../Source/Private/common.ps1"
   . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
   . "$PSScriptRoot/../../Source/Public/$sut"
}

Describe 'VSTeamApproval' -Tag 'unit', 'approvals' {
   BeforeAll {
      # Make sure the project name is valid. By returning an empty array
      # all project names are valid. Otherwise, you name you pass for the
      # project in your commands must appear in the list.
      Mock _getProjects { return @() }

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Release' }

      Mock Invoke-RestMethod {
         # If this test fails uncomment the line below to see how the mock was called.
         # Write-Host $args
         return @{
            count = 1
            value = @(
               @{
                  id       = 1
                  revision = 1
                  approver = @{
                     id          = 'c1f4b9a6-aee1-41f9-a2e0-070a79973ae9'
                     displayName = 'Test User'
                  }
               }
            )
         }
      }
   }

   Context 'Get-VSTeamApproval' {
      Context 'Services' {
         It 'should return approvals' {
            # Act
            Get-VSTeamApproval -projectName project

            # Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It `
               -ParameterFilter {
               $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/approvals?api-version=$(_getApiVersion Release)"
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

         It 'with AssignedToFilter should return approvals only for value passed into AssignedToFilter' {
            # Act
            Get-VSTeamApproval -projectName project -AssignedToFilter 'Chuck Reinhart'

            # Assert
            # With PowerShell core the order of the query string is not the
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order.
            # The general string should look like this:
            # "https://vsrm.dev.azure.com/test/project/_apis/release/approvals/?api-version=$(_getApiVersion Release)&assignedtoFilter=Chuck%20Reinhart&includeMyGroupApprovals=true"
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It `
               -ParameterFilter {
               $Uri -like "*https://vsrm.dev.azure.com/test/project/_apis/release/approvals*" -and
               $Uri -like "*api-version=$(_getApiVersion Release)*" -and
               $Uri -like "*assignedtoFilter=Chuck Reinhart*" -and
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
            Get-VSTeamApproval -projectName project -ReleaseIdsFilter 1 -AssignedToFilter 'Test User' -StatusFilter Pending

            ## Assert
            # With PowerShell core the order of the query string is not the
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order.
            # The general string should look like this:
            # "http://localhost:8080/tfs/defaultcollection/project/_apis/release/approvals/?api-version=$(_getApiVersion Release)&statusFilter=Pending&assignedtoFilter=Test User&includeMyGroupApprovals=true&releaseIdsFilter=1"
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