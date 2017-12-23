Set-StrictMode -Version Latest

if ($null -eq $env:TEAM_CIBUILD) {
   Get-Module VSTeam | Remove-Module -Force
   Import-Module $PSScriptRoot\..\..\vsteam.psd1 -Force
}

Set-VSTeamAPIVersion -Version $env:API_VERSION

Describe 'Team' {
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