Set-StrictMode -Version Latest

Describe "VSTeamGitRepository" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      . "$baseFolder/Source/Classes/VSTeamLeaf.ps1"
      . "$baseFolder/Source/Classes/VSTeamDirectory.ps1"
      . "$baseFolder/Source/Private/common.ps1"
      . "$baseFolder/Source/Private/applyTypes.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamQueue.ps1"
      . "$baseFolder/Source/Public/Remove-VSTeamAccount.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"
      . "$baseFolder/Source/Public/Clear-VSTeamDefaultProject.ps1"
      . "$baseFolder/Source/Private/applyTypes.ps1"

      $results = [PSCustomObject]@{
         value = [PSCustomObject]@{
            id            = ''
            url           = ''
            sshUrl        = ''
            remoteUrl     = ''
            defaultBranch = ''
            size          = [long]0
            name          = ''
            project       = [PSCustomObject]@{
               name        = 'Project'
               id          = '123-5464-dee43'
               description = ''
               url         = ''
               state       = ''
               revision    = [long]0
               visibility  = ''
            }
         }
      }

      $singleResult = [PSCustomObject]@{
         id            = ''
         url           = ''
         sshUrl        = ''
         remoteUrl     = ''
         defaultBranch = ''
         size          = [long]0
         name          = ''
         project       = [PSCustomObject]@{
            name        = 'Project'
            id          = '123-5464-dee43'
            description = ''
            url         = ''
            state       = ''
            revision    = [long]0
            visibility  = ''
         }
      }

      ## Arrange
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Git' }

      ## If you don't call this and there is a default project in scope
      ## these tests will fail. The API can be called with or without
      ## a project and these tests are written to test without one.
      Clear-VSTeamDefaultProject

      Mock Invoke-RestMethod {
         # Write-Host "results $Uri"
         return $results }
      Mock Invoke-RestMethod {
         # Write-Host "Single $Uri"
         return $singleResult } -ParameterFilter {
         $Uri -like "*00000000-0000-0000-0000-000000000000*" -or
         $Uri -like "*testRepo*"
      }
      Mock Invoke-RestMethod {
         # Write-Host "boom $Uri"
         throw [System.Net.WebException] } -ParameterFilter {
         $Uri -like "*00000000-0000-0000-0000-000000000101*" -or
         $Uri -like "*boom*"
      }
   }

   Context 'Get-VSTeamGitRepository' {
      Context 'Services' {
         BeforeAll {
            ## Arrange
            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'https://dev.azure.com/test' }
         }

         It 'no parameters should return all repos for all projects' {
            ## Act
            Get-VSTeamGitRepository

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/git/repositories?api-version=$(_getApiVersion Git)"
            }
         }

         It 'by Id should return a single repo by id' {
            ## Act
            Get-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000000

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/git/repositories/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Git)"
            }
         }

         It 'by name should return a single repo by name' {
            ## Act
            Get-VSTeamGitRepository -Name 'testRepo'

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/git/repositories/testRepo?api-version=$(_getApiVersion Git)"
            }
         }

         It 'by id should throw' {
            ## Act / Assert
            { Get-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000101 } | Should -Throw
         }

         It 'by name should throw' {
            ## Act / Assert
            { Get-VSTeamGitRepository -Name 'boom' } | Should -Throw
         }
      }

      Context 'Server' {
         BeforeAll {
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

            Mock _useWindowsAuthenticationOnPremise { return $true }
         }

         It 'no parameters Should return Git repo' {
            ## Act
            Get-VSTeamGitRepository

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/git/repositories?api-version=$(_getApiVersion Git)"
            }
         }

         It 'by Id should return a single repo by id' {
            ## Act
            Get-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000000

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/git/repositories/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Git)"
            }
         }

         It 'by name should return a single repo by name' {
            ## Act
            Get-VSTeamGitRepository -Name 'testRepo'

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/git/repositories/testRepo?api-version=$(_getApiVersion Git)"
            }
         }
      }
   }
}