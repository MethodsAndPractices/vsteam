Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/$sut"

Describe 'Get-VSTeamApproval' -Tag 'unit', 'approvals' {
   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' }
   
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   # Load the mocks to create the project name dynamic parameter
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   Context 'Handles Exception' {
      # Arrange
      Mock _handleException -Verifiable
      Mock Invoke-RestMethod { throw 'testing error handling' }

      It 'should pass exception to _handleException' {
         # Act
         Get-VSTeamApproval -ProjectName project

         # Assert
         Assert-VerifiableMock
      }
   }

   Context 'Succeeds' {
      # Arrange
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

      It 'should return approvals' {
         # Act
         Get-VSTeamApproval -projectName project

         # Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 `
            -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/approvals?api-version=$([VSTeamVersions]::Release)"
         }
      }
   }

   Context 'Succeeds with AssignedToFilter' {
      # Arrange
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

      It 'should return approvals only for value passed into AssignedToFilter' {
         # Act
         Get-VSTeamApproval -projectName project -AssignedToFilter 'Chuck Reinhart'

         # Assert
         # With PowerShell core the order of the query string is not the
         # same from run to run!  So instead of testing the entire string
         # matches I have to search for the portions I expect but can't
         # assume the order.
         # The general string should look like this:
         # "https://vsrm.dev.azure.com/test/project/_apis/release/approvals/?api-version=$([VSTeamVersions]::Release)&assignedtoFilter=Chuck%20Reinhart&includeMyGroupApprovals=true"
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 `
            -ParameterFilter {
            $Uri -like "*https://vsrm.dev.azure.com/test/project/_apis/release/approvals*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Release)*" -and
            $Uri -like "*assignedtoFilter=Chuck Reinhart*" -and
            $Uri -like "*includeMyGroupApprovals=true*"
         }
      }
   }

   Context 'Succeeds on TFS' {
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

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
         } }

      Get-VSTeamApproval -projectName project -ReleaseIdsFilter 1 -AssignedToFilter 'Test User' -StatusFilter Pending

      It 'should return approvals' {
         # With PowerShell core the order of the query string is not the
         # same from run to run!  So instead of testing the entire string
         # matches I have to search for the portions I expect but can't
         # assume the order.
         # The general string should look like this:
         # "http://localhost:8080/tfs/defaultcollection/project/_apis/release/approvals/?api-version=$([VSTeamVersions]::Release)&statusFilter=Pending&assignedtoFilter=Test User&includeMyGroupApprovals=true&releaseIdsFilter=1"
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 `
            -ParameterFilter {
            $Uri -like "*http://localhost:8080/tfs/defaultcollection/project/_apis/release/approvals*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::Release)*" -and
            $Uri -like "*statusFilter=Pending*" -and
            $Uri -like "*assignedtoFilter=Test User*" -and
            $Uri -like "*includeMyGroupApprovals=true*" -and
            $Uri -like "*releaseIdsFilter=1*"
         }
      }
   }
}