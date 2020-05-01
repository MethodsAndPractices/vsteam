Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Classes/VSTeamTeam.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeam.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe "VSTeam" {
   $singleResult = [PSCustomObject]@{
      id          = '6f365a7143e492e911c341451a734401bcacadfd'
      name        = 'refs/heads/master'
      description = 'team description'
   }
   
   Context "Get-VSTeam" {
      Context "services" {
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }

         Context 'Update-VSTeam without name or description' {
            It 'Should throw' {
               { Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" } | Should Throw
            }
         }

         Context 'Update-VSTeam with new team name' {
            Mock Invoke-RestMethod { return $singleResult }

            It 'Should update the team' {
               Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -NewTeamName "NewTeamName"

               $expectedBody = '{ "name": "NewTeamName" }'

               Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/projects/Test/teams/OldTeamName?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Patch" -and
                  $Body -eq $expectedBody
               }
            }
         }

         Context 'Update-VSTeam with new description' {
            Mock Invoke-RestMethod { return $singleResult }

            It 'Should update the team' {
               Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -Description "New Description"

               $expectedBody = '{"description": "New Description" }'

               Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/projects/Test/teams/OldTeamName?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Patch" -and
                  $Body -eq $expectedBody
               }
            }
         }

         Context 'Update-VSTeam with new team name and description' {
            Mock Invoke-RestMethod { return $singleResult }

            It 'Should update the team' {
               Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -NewTeamName "NewTeamName" -Description "New Description"

               $expectedBody = '{ "name": "NewTeamName", "description": "New Description" }'

               Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/projects/Test/teams/OldTeamName?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Patch" -and
                  $Body -eq $expectedBody
               }
            }
         }

         Context 'Update-VSTeam, fed through pipeline' {
            Mock Get-VSTeam { return New-Object -TypeName PSObject -Prop @{projectname = "TestProject"; name = "OldTeamName" } }
            Mock Invoke-RestMethod { return $singleResult }

            It 'Should update the team' {
               Get-VSTeam -ProjectName TestProject -TeamId "OldTeamName" | Update-VSTeam -NewTeamName "NewTeamName" -Description "New Description"

               $expectedBody = '{ "name": "NewTeamName", "description": "New Description" }'

               Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/projects/TestProject/teams/OldTeamName?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Patch" -and
                  $Body -eq $expectedBody
               }
            }
         }
      }


      Context "Server" {
         Mock _useWindowsAuthenticationOnPremise { return $true }

         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

         Context 'Update-VSTeam with new team name on TFS local Auth' {
            Mock Invoke-RestMethod { return $singleResult }

            It 'Should update the team' {
               Update-VSTeam -ProjectName Test -TeamToUpdate "OldTeamName" -NewTeamName "NewTeamName"

               $expectedBody = '{ "name": "NewTeamName" }'

               Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/projects/Test/teams/OldTeamName?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Patch" -and
                  $Body -eq $expectedBody
               }
            }
         }
      }
   }
}