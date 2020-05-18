Set-StrictMode -Version Latest

Describe 'Team' -Tag 'integration' {
   BeforeAll {
      Set-VSTeamAPIVersion -Target $env:API_VERSION
      $pat = $env:PAT
      $acct = $env:ACCT
      $api = $env:API_VERSION
      Set-VSTeamAccount -a $acct -pe $pat -version $api

      # See if there are any existing projects. If so use the 
      # first one as the expected project name. If there are none
      # simply use MyProject
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
}