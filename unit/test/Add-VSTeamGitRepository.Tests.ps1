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
      . "$PSScriptRoot/../../Source/Classes/VSTeamRelease.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamQueue.ps1"
      . "$PSScriptRoot/../../Source/Public/Remove-VSTeamAccount.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())
   }

   Context 'Add-VSTeamGitRepository' {
      ## Arrange
      BeforeAll {
         $singleResult = [PSCustomObject]@{
            id            = ''
            url           = ''
            sshUrl        = ''
            remoteUrl     = ''
            defaultBranch = ''
            size          = [long]0
            name          = 'testRepo'
            project       = [PSCustomObject]@{
               name        = 'Project'
               id          = '00000000-0000-0000-0000-000000000001'
               description = ''
               url         = ''
               state       = ''
               revision    = [long]0
               visibility  = ''
            }
         }

         Mock Invoke-RestMethod { return $singleResult }

         Mock _getInstance { return 'https://dev.azure.com/test' }
         Mock _getApiVersion { return '1.0-gitUnitTests' } -ParameterFilter { $Service -eq 'Git' }
      }

      It 'by name should add Git repo' {
         Add-VSTeamGitRepository -Name 'testRepo' -ProjectName 'test'

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Post" -and
            $Uri -eq "https://dev.azure.com/test/test/_apis/git/repositories?api-version=1.0-gitUnitTests" -and
            $Body -like "*testRepo*"
         }
      }
   }
}