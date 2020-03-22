Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/Get-VSTeamProject.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamQueue' {
   ## Arrange
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   Mock _getInstance { return 'https://dev.azure.com/test' }
      
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

   Mock Invoke-RestMethod { return @{ value = @{ id = 3; name = 'Hosted'; pool = @{ } } } }
   Mock Invoke-RestMethod { return @{ id = 101; name = 'Hosted'; pool = @{ } } } -ParameterFilter {
      $Uri -like "*101*"
   }
      
   Context 'Get-VSTeamQueue' {
      It 'should return requested queue' {
         ## Act
         Get-VSTeamQueue -projectName project -queueId 101
   
         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/queues/101?api-version=$([VSTeamVersions]::DistributedTask)"
         }
      }

      it 'with actionFilter & queueName parameter should return all the queues' {
         ## Act
         Get-VSTeamQueue -projectName project -actionFilter 'None' -queueName 'Hosted'

         # With PowerShell core the order of the query string is not the
         # same from run to run!  So instead of testing the entire string
         # matches I have to search for the portions I expect but can't
         # assume the order.
         # The general string should look like this:
         # "https://dev.azure.com/test/project/_apis/distributedtask/queues/?api-version=$([VSTeamVersions]::DistributedTask)&actionFilter=None&queueName=Hosted"
         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/project/_apis/distributedtask/queues*" -and
            $Uri -like "*api-version=$([VSTeamVersions]::DistributedTask)*" -and
            $Uri -like "*actionFilter=None*" -and
            $Uri -like "*queueName=Hosted*"
         }
      }

      it 'with no parameters should return all the queues' {
         ## Act
         Get-VSTeamQueue -ProjectName project

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/queues?api-version=$([VSTeamVersions]::DistributedTask)"
         }
      }

      it 'with queueName parameter should return all the queues' {
         ## Act
         Get-VSTeamQueue -projectName project -queueName 'Hosted'

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/queues?api-version=$([VSTeamVersions]::DistributedTask)&queueName=Hosted"
         }
      }

      it 'with actionFilter parameter should return all the queues' {
         ## Act
         Get-VSTeamQueue -projectName project -actionFilter 'None'

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/queues?api-version=$([VSTeamVersions]::DistributedTask)&actionFilter=None"
         }
      }
   }
}