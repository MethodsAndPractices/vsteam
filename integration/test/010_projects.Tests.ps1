Set-StrictMode -Version Latest

if ($null -eq $env:TEAM_CIBUILD) {
   Get-Module VSTeam | Remove-Module -Force
   Import-Module $PSScriptRoot\..\..\vsteam.psd1 -Force
}

# Before running these tests you must set the following
# Environment variables.
# $env:API_VERSION = TFS2017, TFS2018 or VSTS depending on the value used for ACCT
# $env:EMAIL = Email of user to remove and re-add to account
# $env:ACCT = VSTS Account Name or full TFS URL including collection
# $env:PAT = Personal Access token of ACCT

Set-VSTeamAPIVersion -Version $env:API_VERSION

Describe 'VSTeam Integration Tests' {
   BeforeAll {
      $pat = $env:PAT
      $acct = $env:ACCT
      $api = $env:API_VERSION
      $email = $env:EMAIL
      $projectName = 'TeamModuleIntegration' + [guid]::NewGuid().toString().substring(0, 5)
      $newProjectName = $projectName + [guid]::NewGuid().toString().substring(0, 5) + '1'

      $originalLocation = Get-Location

      $oAcct = $null
      $profile = Get-Profile | Where-Object url -like "*$acct*"

      if ($profile) {
         # Save current profile data
         $oAcct = $profile.URL
         $oVersion = $profile.Version
         $oName = $profile.Name
      }

      Add-VSTeamProfile -Account $acct -PersonalAccessToken $pat -Version $api -Name intTests
      Add-VSTeamAccount -Profile intTests -Drive int
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
         Add-VSTeamProject -Name $projectName | Should Not Be $null
      }

      It 'Get-VSTeamProject Should return projects' {
         Get-VSTeamProject -Name $projectName -IncludeCapabilities | Should Not Be $null
      }

      It 'Update-VSTeamProject Should update description' {
         Update-VSTeamProject -Name $projectName -NewDescription 'Test Description' -Force

         Get-VSTeamProject -Name $projectName | Select-Object -ExpandProperty 'Description' | Should Be 'Test Description'
      }

      It 'Update-VSTeamProject Should update name' {
         Update-VSTeamProject -Name $projectName -NewName $newProjectName -Force

         Get-VSTeamProject -Name $newProjectName | Select-Object -ExpandProperty 'Description' | Should Be 'Test Description'
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
         Set-Location $newProjectName
         Get-ChildItem | Should Not Be $null
      }

      It 'Should list Teams' {
         Set-Location 'Teams'
         Get-ChildItem | Should Not Be $null
      }
   }
   
   Context 'Git full exercise' {
      It 'Get-VSTeamGitRepository Should return repository' {
         Get-VSTeamGitRepository -ProjectName $newProjectName | Select-Object -ExpandProperty Name | Should Be $newProjectName
      }

      It 'Add-VSTeamGitRepository Should create repository' {
         Add-VSTeamGitRepository -ProjectName $newProjectName -Name 'testing'
         (Get-VSTeamGitRepository -ProjectName $newProjectName).Count | Should Be 2
         Get-VSTeamGitRepository -ProjectName $newProjectName -Name 'testing' | Select-Object -ExpandProperty Name | Should Be 'testing'
      }

      It 'Remove-VSTeamGitRepository Should delete repository' {
         Get-VSTeamGitRepository -ProjectName $newProjectName -Name 'testing' | Select-Object -ExpandProperty Id | Remove-VSTeamGitRepository -Force
         Get-VSTeamGitRepository -ProjectName $newProjectName | Where-Object { $_.Name -eq 'testing' } | Should Be $null
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
      It 'Get-VSTeamQueue Should return agent Queues' {
         $actual = Get-VSTeamQueue -ProjectName $newProjectName

         if ($acct -like "http://*") {
            $global:queueId = $actual.id
            $actual.name | Should Be 'Default'
         }
         else {
            $global:queueId = $actual[0].id
            $actual.Count | Should Be 5
         }
      }

      It 'Get-VSTeamQueue By Id Should return agent Queue' {
         $actual = Get-VSTeamQueue -ProjectName $newProjectName -Id $global:queueId
         
         $actual | Should Not Be $null
      }
   }

   Context 'Service Endpoints full exercise' {
      It 'Add-VSTeamSonarQubeEndpoint Should add servcie endpoint' {
         { Add-VSTeamSonarQubeEndpoint -ProjectName $newProjectName -EndpointName 'TestSonarQube' `
               -SonarQubeURl 'http://sonarqube.somewhereIn.cloudapp.azure.com:9000' -PersonalAccessToken 'Faketoken' } | Should Not Throw
      }

      It 'Add-VSTeamAzureRMServiceEndpoint Should add servcie endpoint' {
         { Add-VSTeamAzureRMServiceEndpoint -ProjectName $newProjectName -displayName 'AzureEndoint' `
               -subscriptionId '00000000-0000-0000-0000-000000000000' -subscriptionTenantId '00000000-0000-0000-0000-000000000000' `
               -servicePrincipalId '00000000-0000-0000-0000-000000000000' -servicePrincipalKey 'fakekey' } | Should Not Throw
      }

      It 'Get-VSTeamServiceEndpoint Should return service endpoints' {
         $actual = Get-VSTeamServiceEndpoint -ProjectName $newProjectName

         $actual.Count | Should Be 2
      }

      It 'Remove-VSTeamServiceEndpoint Should delete service endpoints' {
         Get-VSTeamServiceEndpoint -ProjectName $newProjectName | Remove-VSTeamServiceEndpoint -ProjectName $newProjectName -Force

         Get-VSTeamServiceEndpoint -ProjectName $newProjectName | Should Be $null
      }
   }

   # Not supported on TFS
   if (-not ($acct -like "http://*")) {
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
            Add-VSTeamUser -Email $email -License StakeHolder | Should Not Be $null
            (Get-VSTeamUser).Count | Should Be 2
         }
      }
   }

   Context 'Teams full exercise' {
      It 'Get-VSTeam ByName Should return Teams' {
         Get-VSTeam -ProjectName $newProjectName -Name "$newProjectName Team" | Should Not Be $null
      }

      $global:id = (Get-VSTeam -ProjectName $newProjectName).Id

      It 'Get-VSTeam ById Should return Teams' {
         Get-VSTeam -ProjectName $newProjectName -Id $global:id | Should Not Be $null
      }

      It 'Get-VSTeamMembers Should return TeamMembers' {
         Get-VSTeamMember -ProjectName $newProjectName -TeamId $global:id | Should Not Be $null
      }

      It 'Add-VSTeam should add a team' {
         Add-VSTeam -ProjectName $newProjectName -Name 'testing' | Should Not Be $null
         (Get-VSTeam -ProjectName $newProjectName).Count | Should Be 2
      }

      It 'Update-VSTeam should update a team' {
         Update-VSTeam -ProjectName $newProjectName -Name 'testing' -NewTeamName 'testing123'
         Get-VSTeam -ProjectName $newProjectName -Name 'testing123' | Should Not Be $null
      }

      It 'Remove-VSTeam should delete the team' {
         Remove-VSTeam -ProjectName $newProjectName -Name 'testing123' -Force
         Get-VSTeam -ProjectName $newProjectName | Where-Object { $_.Name -eq 'testing123'} | Should Be $null
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
         $Global:PSDefaultParameterValues['*:projectName'] = $newProjectName
         
         Clear-VSTeamDefaultProject
         
         $Global:PSDefaultParameterValues['*:projectName'] | Should BeNullOrEmpty
      }

      It 'Remove-VSTeamProject Should remove Project' {
         Remove-VSTeamProject -ProjectName $newProjectName -Force
      }

      It 'Remove-VSTeamAccount Should remove account' {
         Remove-VSTeamAccount
      }
   }

   AfterAll {
      # Put everything back
      Set-Location $originalLocation
 
      if ($oAcct) { 
         Add-VSTeamProfile -Account $oAcct -PersonalAccessToken $pat -Version $oVersion -Name $oName
         Add-VSTeamAccount -Profile $oName
      }
   } 
}