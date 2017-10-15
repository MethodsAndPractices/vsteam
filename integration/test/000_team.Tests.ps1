Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force

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
         Add-VSTeamAccount -a $acct -pe $pat

         $info = Get-VSTeamInfo
         
         $info.DefaultProject | Should Be $null
         $info.Account | Should Be "https://$acct.visualstudio.com"
      }
   }

   Context 'Remove-TeamAccount run as normal user' {
      It 'should clear env at process level' {
         # Act
         Remove-TeamAccount

         # Assert
         $info = Get-VSTeamInfo
         
         $info.Account | Should Be $null
         $info.DefaultProject | Should Be $null
      }
   }

   Context 'Set-VSTeamDefaultProject' {
      It 'should set default project' {
         Set-VSTeamDefaultProject 'MyProject'

         $Global:PSDefaultParameterValues['*:projectName'] | Should be 'MyProject'
      }

      It 'should update default project' {
         $Global:PSDefaultParameterValues['*:projectName'] = 'MyProject'

         Set-VSTeamDefaultProject -Project 'NextProject'

         $Global:PSDefaultParameterValues['*:projectName'] | Should be 'NextProject'
      }
   }

   Context 'Clear-VSTeamDefaultProject' {
      It 'should clear default project' {
         $Global:PSDefaultParameterValues['*:projectName'] = 'MyProject'

         Clear-VSTeamDefaultProject

         $Global:PSDefaultParameterValues['*:projectName'] | Should BeNullOrEmpty
      }
   }
}