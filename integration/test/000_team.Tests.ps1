Set-StrictMode -Version Latest

Describe 'Team' -Tag 'integration' {
   BeforeAll {
      . "$PSScriptRoot/testprep.ps1"

      Set-TestPrep
   
      $acct = $env:ACCT

      # See if there are any existing projects. If so use the
      # first one as the expected project name. If there are none
      # simply use MyProject
      # We can't use Get-ProjectName here as the name as to be an existing
      # project name unless no projects exisit.
      $expectedProjectName = Get-VSTeamProject | Select-Object -First 1 -ExpandProperty Name

      if (-not $expectedProjectName) {
         $expectedProjectName = 'MyProject'
      }
   }

   Context 'Set-VSTeamDefaultProject' {
      It 'should set default project' {
         Set-VSTeamDefaultProject -Project $expectedProjectName

         $info = Get-VSTeamInfo

         $info.DefaultProject | Should -Be $expectedProjectName
      }
   }

   Context 'Clear-VSTeamDefaultProject' {
      It 'should clear default project' {
         Set-VSTeamDefaultProject -Project $expectedProjectName

         Clear-VSTeamDefaultProject

         $info = Get-VSTeamInfo

         $info.DefaultProject | Should -BeNullOrEmpty
      }
   }

   Context 'Get-VSTeamInfo' {
      BeforeAll {
         # Set-VSTeamAccount is set in the Before All
         # so just set the default project here
         # Arrange
         Set-VSTeamDefaultProject -Project $expectedProjectName

         # Act
         $info = Get-VSTeamInfo
      }

      # Assert
      It 'should return account' {
         # The account for Server is formated different than for Services
         if ($acct -like "http://*") {
            $info.Account | Should -Be $acct
         }
         else {
            $info.Account | Should -Be "https://dev.azure.com/$($env:ACCT)"
         }
      }

      It 'should return default project' {
         $info.DefaultProject | Should -Be $expectedProjectName
      }
   }

   Context 'Remove-VSTeamAccount run as normal user' {
      It 'should clear env at process level' {
         # Act
         Remove-VSTeamAccount

         # Assert
         $info = Get-VSTeamInfo

         $info.Account | Should -Be ''
         $info.DefaultProject | Should -Be $null
      }
   }

   Context 'Profile full exercise' {
      BeforeAll {
         Add-VSTeamProfile -Name inttests -Account intTests -PersonalAccessToken 00000000-0000-0000-0000-000000000000
      }
      It 'Get-VSTeamProfile' {
         Get-VSTeamProfile inttests | Should -Not -Be $null
      }

      It 'Remove-VSTeamProfile' {
         Remove-VSTeamProfile inttests -Force
      }
   }
}