Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
Import-Module $PSScriptRoot\..\..\vsteam.psd1 -Force

Set-VSTeamAPIVersion -Version $env:API_VERSION

Describe 'VSTeam Integration Tests' {
   BeforeAll {
      $pat = $env:PAT
      $acct = $env:ACCT
      $api = $env:API_VERSION
      $email = $env:EMAIL

      Add-VSTeamProfile -Account $acct -PersonalAccessToken $pat -Version $api -Name intTests
      Add-VSTeamAccount -Profile intTests -Drive int
   }   

   Context 'Profile full exercise' {
      It 'Get-VSTeamProfile' {
         Get-VSTeamProfile inttests | Should Not Be $null
      }

      It 'Remove-VSTeamProfile' {
         Remove-VSTeamProfile inttests -Force
      }
   }

   Context 'Project full exercise' {
      It 'Add-VSTeamProject Should create project' {
         Add-VSTeamProject -ProjectName 'TeamModuleIntegration' | Should Not Be $null
      }

      It 'Get-VSTeamProject Should return projects' {
         Get-VSTeamProject -ProjectName 'TeamModuleIntegration'  | Should Not Be $null
      }

      It 'Update-VSTeamProject Should update description' {
         Update-VSTeamProject -ProjectName 'TeamModuleIntegration' -NewDescription 'Test Description' -Force

         Get-VSTeamProject -ProjectName 'TeamModuleIntegration' | Select-Object -ExpandProperty 'Description' | Should Be 'Test Description'
      }

      It 'Update-VSTeamProject Should update name' {
         Update-VSTeamProject -ProjectName 'TeamModuleIntegration' -NewName 'TeamModuleIntegration1' -Force

         Get-VSTeamProject -ProjectName 'TeamModuleIntegration1' | Select-Object -ExpandProperty 'Description' | Should Be 'Test Description'
      }
   }

   Context 'PS Drive full exercise' {
      New-PSDrive -Name int -PSProvider SHiPS -Root 'VSTeam#VSAccount'
      $actual = Set-Location int: -PassThru

      It 'Should be able to mount drive' {
         $actual | Should Not Be $null
      }

      It 'Should list projects' {
         Get-ChildItem | Should Not Be $null
      }

      It 'Should list Builds, Releases and Teams' {
         Set-Location 'TeamModuleIntegration1'
         Get-ChildItem | Should Not Be $null
      }

      It 'Should list Teams' {
         Set-Location 'Teams'
         Get-ChildItem | Should Not Be $null
      }
   }
   
   Context 'Git full exercise' {
      It 'Get-VSTeamGitRepository Should return repository' {
         Get-VSTeamGitRepository -ProjectName 'TeamModuleIntegration1' | Select-Object -ExpandProperty Name | Should Be 'TeamModuleIntegration1'
      }

      It 'Add-VSTeamGitRepository Should create repository' {
         Add-VSTeamGitRepository -ProjectName 'TeamModuleIntegration1' -Name 'testing'
         (Get-VSTeamGitRepository -ProjectName 'TeamModuleIntegration1').Count | Should Be 2
         Get-VSTeamGitRepository -ProjectName 'TeamModuleIntegration1' -Name 'testing' | Select-Object -ExpandProperty Name | Should Be 'testing'
      }

      It 'Remove-VSTeamGitRepository Should delete repository' {
         Get-VSTeamGitRepository -ProjectName 'TeamModuleIntegration1' -Name 'testing' | Select-Object -ExpandProperty Id | Remove-VSTeamGitRepository -Force
         Get-VSTeamGitRepository -ProjectName 'TeamModuleIntegration1' | Where-Object { $_.Name -eq 'testing' } | Should Be $null
      }
   }

   Context 'Pool full exercise' {
      It 'Get-VSTeamPool Should return agent pools' {
         $actual = Get-VSTeamPool

         if ($acct -like "http://*") {
            $actual.name | Should Be 'Default'
         }
         else {
            $actual.Count | Should Be 5
         }
      }
   }

   Context 'Queue full exercise' {
      $id = 0

      It 'Get-VSTeamQueue Should return agent Queues' {
         $actual = Get-VSTeamQueue -ProjectName 'TeamModuleIntegration1'

         if ($acct -like "http://*") {
            $actual.name | Should Be 'Default'
            $id = $actual.id
         }
         else {
            $actual.Count | Should Be 5
            $id = $actual[0].id
         }
      }

      It 'Get-VSTeamQueue By Id Should return agent Queue' {
         $actual = Get-VSTeamQueue -ProjectName 'TeamModuleIntegration1' -Id $id
         
         $actual | Should Not Be $null
      }
   }

   Context 'Service Endpoints full exercise' {
      It 'Add-VSTeamSonarQubeEndpoint Should add servcie endpoint' {
         Add-VSTeamSonarQubeEndpoint -ProjectName 'TeamModuleIntegration1' -EndpointName 'TestSonarQube' `
            -SonarQubeURl 'http://sonarqube.somewhereIn.cloudapp.azure.com:9000' -PersonalAccessToken 'Faketoken' | Should Not Be $null
      }

      It 'Add-VSTeamAzureRMServiceEndpoint Should add servcie endpoint' {
         Add-VSTeamAzureRMServiceEndpoint -ProjectName 'TeamModuleIntegration1' -displayName 'AzureEndoint' `
            -subscriptionId '00000000-0000-0000-0000-000000000000' -subscriptionTenantId '00000000-0000-0000-0000-000000000000' `
            -servicePrincipalId '00000000-0000-0000-0000-000000000000' -servicePrincipalKey 'fakekey' | Should Not Be $null
      }

      It 'Get-VSTeamServiceEndpoint Should return service endpoints' {
         $actual = Get-VSTeamServiceEndpoint -ProjectName 'TeamModuleIntegration1'

         $actual.Count | Should Be 2
      }

      It 'Remove-VSTeamServiceEndpoint Should delete service endpoints' {
         Get-VSTeamServiceEndpoint -ProjectName 'TeamModuleIntegration1' | Remove-VSTeamServiceEndpoint -ProjectName 'TeamModuleIntegration1' -Force

         Get-VSTeamServiceEndpoint -ProjectName 'TeamModuleIntegration1' | Should Be $null
      }
   }

   Context 'Users exercise' {
    
      It 'Get-VSTeamUser Should return all usrs' {
         Get-VSTeamUser | Should Not Be $null         
      }

      It 'Get-VSTeamUser ById Should return Teams' {
         $id = (Get-VSTeamUser | Where-Object email -eq $email).Id
         Get-VSTeamUser -Id $id | Should Not Be $null
      }

      It 'Remove-VSTeamUser should fail' {
         { Remove-VSTeamUser -Email fake@NoteReal.foo -Force } | Should Throw
      }
      
      It 'Remove-VSTeamUser should delete the team' {
         Remove-VSTeamUser -Email $email -Force
         Get-VSTeamUser | Where-Object Email -eq $email | Should Be $null
      }

      It 'Add-VSTeamUser should add a team' {
         Add-VSTeamUser -Email $email | Should Not Be $null
         (Get-VSTeamUser).Count | Should Be 2
      }
   }

   Context 'Teams full exercise' {
      It 'Get-VSTeam ByName Should return Teams' {
         Get-VSTeam -ProjectName 'TeamModuleIntegration1' -Name 'TeamModuleIntegration1 Team' | Should Not Be $null
      }

      $id = (Get-VSTeam -ProjectName 'TeamModuleIntegration1').Id

      It 'Get-VSTeam ById Should return Teams' {
         Get-VSTeam -ProjectName 'TeamModuleIntegration1' -Id $id | Should Not Be $null
      }

      It 'Get-VSTeamMembers Should return TeamMembers' {
         Get-VSTeamMember -ProjectName 'TeamModuleIntegration1' -Id $id | Should Not Be $null
      }

      It 'Add-VSTeam should add a team' {
         Add-VSTeam -ProjectName 'TeamModuleIntegration1' -Name 'testing' | Should Not Be $null
         (Get-VSTeam -ProjectName 'TeamModuleIntegration1').Count | Should Be 2
      }

      It 'Update-VSTeam should update a team' {
         Update-VSTeam -ProjectName 'TeamModuleIntegration1' -Name 'testing' -NewTeamName 'testing123'
         Get-VSTeam -ProjectName 'TeamModuleIntegration1' -Name 'testing123' | Should Not Be $null
      }

      It 'Remove-VSTeam should delete the team' {
         Remove-VSTeam -ProjectName 'TeamModuleIntegration1' -Name 'testing123' -Force
         Get-VSTeam -ProjectName 'TeamModuleIntegration1' | Where-Object { $_.Name -eq 'testing123'} | Should Be $null
      }
   }

   Context 'Team full exercise' {
      It 'Set-VSTeamAPIVersion to TFS2018' {
         Set-VSTeamAPIVersion TFS2018

         $VSTeamVersionTable.Version | Should Be 'TFS2018'
      }

      It 'Set-VSTeamAPIVersion to TFS2017' {
         Set-VSTeamAPIVersion TFS2017

         $VSTeamVersionTable.Version | Should Be 'TFS2017'
      }

      It 'Clear-VSTeamDefaultProject should clear project' {
         $Global:PSDefaultParameterValues['*:projectName'] = 'TeamModuleIntegration1'
         
         Clear-VSTeamDefaultProject
         
         $Global:PSDefaultParameterValues['*:projectName'] | Should BeNullOrEmpty
      }

      It 'Remove-VSTeamAccount Should remove account' {
         Remove-VSTeamAccount
      }
   }

   AfterAll {
      Get-VSTeamProject | Remove-VSTeamProject -Force

      Remove-TeamAccount
   } 
}