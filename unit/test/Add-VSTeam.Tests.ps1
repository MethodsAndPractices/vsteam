Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamTeam.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion


Describe "VSTeam" {
   $singleResult = [PSCustomObject]@{
      id          = '6f365a7143e492e911c341451a734401bcacadfd'
      name        = 'refs/heads/master'
      description = 'team description'
   }   

   Context "Add-VSTeam" {
      Context "Services" {
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }

         . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

         Context 'Add-VSTeam with team name only' {
            Mock Invoke-RestMethod { return $singleResult }

            It 'Should create a team' {
               Add-VSTeam -ProjectName Test -TeamName "TestTeam"

               $expectedBody = '{ "name": "TestTeam", "description": "" }'

               Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/projects/Test/teams?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Post" -and
                  $Body -eq $expectedBody
               }
            }
         }

         Context 'Add-VSTeam with team name and description' {
            Mock Invoke-RestMethod { return $singleResult }

            It 'Should create a team' {
               Add-VSTeam -ProjectName Test -TeamName "TestTeam" -Description "Test Description"

               $expectedBody = '{ "name": "TestTeam", "description": "Test Description" }'

               Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/projects/Test/teams?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Post" -and
                  $Body -eq $expectedBody
               }
            }
         }
      }

      Context "Server" {
         . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

         Mock _useWindowsAuthenticationOnPremise { return $true }

         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

         Mock Invoke-RestMethod { return $singleResult }

         It 'with team name only on TFS local Auth should create a team' {
            Add-VSTeam -ProjectName Test -TeamName "TestTeam"

            $expectedBody = '{ "name": "TestTeam", "description": "" }'

            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/projects/Test/teams?api-version=$(_getApiVersion Core)" -and
               $Method -eq "Post" -and
               $Body -eq $expectedBody
            }
         }
      }
   }
}