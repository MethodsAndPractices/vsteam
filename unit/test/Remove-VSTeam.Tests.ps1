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
. "$here/../../Source/Public/Get-VSTeam.ps1"
. "$here/../../Source/Public/$sut"
#endregion


$results = [PSCustomObject]@{
   value = [PSCustomObject]@{
      id          = '6f365a7143e492e911c341451a734401bcacadfd'
      name        = 'refs/heads/master'
      description = 'team description'
   }
}

$singleResult = [PSCustomObject]@{
   id          = '6f365a7143e492e911c341451a734401bcacadfd'
   name        = 'refs/heads/master'
   description = 'team description'
}
   
Describe "VSTeam" {
   Context "Get-VSTeam" {
      Context "services" {
         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }

         . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

         Context 'Remove-VSTeam' {
            Mock Invoke-RestMethod { return $singleResult }

            It 'Should remove the team' {
               Remove-VSTeam -ProjectName Test -TeamId "TestTeam" -Force

               Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/projects/Test/teams/TestTeam?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Delete"
               }
            }
         }

         Context 'Remove-VSTeam, fed through pipeline' {
            Mock Get-VSTeam { return New-Object -TypeName PSObject -Prop @{projectname = "TestProject"; name = "TestTeam" } }
            Mock Invoke-RestMethod { return $singleResult }

            It 'Should remove the team' {
               Get-VSTeam -ProjectName TestProject -TeamId "TestTeam" | Remove-VSTeam -Force

               Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "https://dev.azure.com/test/_apis/projects/TestProject/teams/TestTeam?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Delete"
               }
            }
         }
      }


      Context "Server" {
         . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

         Mock _useWindowsAuthenticationOnPremise { return $true }

         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

         Context 'Remove-VSTeam on TFS local Auth' {
            Mock Invoke-RestMethod { return $singleResult }

            It 'Should remove the team' {
               Remove-VSTeam -ProjectName Test -TeamId "TestTeam" -Force

               Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
                  $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/projects/Test/teams/TestTeam?api-version=$(_getApiVersion Core)" -and
                  $Method -eq "Delete"
               }
            }
         }
      }
   }
}