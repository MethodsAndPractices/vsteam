Set-StrictMode -Version Latest

Describe "VSTeamGitRepository" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      . "$baseFolder/Source/Classes/VSTeamLeaf.ps1"
      . "$baseFolder/Source/Classes/VSTeamDirectory.ps1"
      . "$baseFolder/Source/Classes/VSTeamTask.ps1"
      . "$baseFolder/Source/Classes/VSTeamAttempt.ps1"
      . "$baseFolder/Source/Classes/VSTeamEnvironment.ps1"
      . "$baseFolder/Source/Private/applyTypes.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamQueue.ps1"
      . "$baseFolder/Source/Public/Remove-VSTeamAccount.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamBuildDefinition.ps1"
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