Set-StrictMode -Version Latest

Describe "VSTeamGitRepository" {
   BeforeAll {
      Import-Module SHiPS
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTask.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamAttempt.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamEnvironment.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamQueue.ps1"
      . "$PSScriptRoot/../../Source/Public/Remove-VSTeamAccount.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())

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