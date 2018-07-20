Set-StrictMode -Version Latest

if ($null -eq $env:TEAM_CIBUILD) {
   Get-Module VSTeam | Remove-Module -Force
   Import-Module $PSScriptRoot\..\..\VSTeam.psd1 -Force
}

# Before running these tests you must set the following
# Environment variables.
# $env:API_VERSION = TFS2017, TFS2018 or VSTS depending on the value used for ACCT
# $env:EMAIL = Email of user to remove and re-add to account
# $env:ACCT = VSTS Account Name or full TFS URL including collection
# $env:PAT = Personal Access token of ACCT

Set-VSTeamAPIVersion -Version $env:API_VERSION

Describe 'Team' -Tag 'integration' {
   BeforeAll {
      $pat = $env:PAT
      $acct = $env:ACCT
      $api = $env:API_VERSION
      Add-VSTeamAccount -a $acct -pe $pat -version $api
         
      Get-VSTeamProject | Remove-VSTeamProject -Force
   }

   Context 'Get-VSTeamInfo' {
      It 'should return account and default project' {
         $VSTeamVersionTable.Account = "mydemos"
         $Global:PSDefaultParameterValues['*:projectName'] = 'MyProject'

         $info = Get-VSTeamInfo

         $info.Account | Should Be "mydemos"
         $info.DefaultProject | Should Be "MyProject"
      }
   }

   Context 'Add-VSTeamAccount vsts' {
      It 'should set env at process level' {
         $pat = $env:PAT
         $acct = $env:ACCT
         $api = $env:API_VERSION
         Add-VSTeamAccount -a $acct -pe $pat -version $api

         $info = Get-VSTeamInfo
         
         $info.DefaultProject | Should Be $null

         if ($acct -like "http://*") {
            $info.Account | Should Be $acct
         }
         else {
            $info.Account | Should Be "https://$acct.visualstudio.com"
         }
      }
   }

   Context 'Remove-TeamAccount run as normal user' {
      It 'should clear env at process level' {
         # Act
         Remove-TeamAccount

         # Assert
         $info = Get-VSTeamInfo
         
         $info.Account | Should Be ''
         $info.DefaultProject | Should Be $null
      }
   }
}