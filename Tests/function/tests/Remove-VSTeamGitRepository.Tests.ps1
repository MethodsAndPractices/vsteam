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
      . "$baseFolder/Source/Private/applyTypes.ps1"

      ## Arrange
      $singleResult = [PSCustomObject]@{
         id            = ''
         url           = ''
         sshUrl        = ''
         remoteUrl     = ''
         defaultBranch = ''
         size          = 0
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

   Context 'Remove-VSTeamGitRepository' {
      Context 'Services' {
         BeforeAll {
            ## Arrange
            Mock _getInstance { return 'https://dev.azure.com/test' }
         }

         It 'by id should remove Git repo' {
            ## Act
            Remove-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000000 -Force

            ## Assert
            Should -Invoke Invoke-RestMethod -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq "https://dev.azure.com/test/_apis/git/repositories/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Git)"
            }
         }

         It 'by Id should throw' {
            { Remove-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000101 -Force } | Should -Throw
         }
      }

      Context 'Server' {
         BeforeAll {
            ## Arrange
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         }

         It 'by id should remove Git repo' {
            ## Act
            Remove-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000000 -Force

            ## Assert
            Should -Invoke Invoke-RestMethod -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/git/repositories/00000000-0000-0000-0000-000000000000?api-version=$(_getApiVersion Git)"
            }
         }
      }
   }
}