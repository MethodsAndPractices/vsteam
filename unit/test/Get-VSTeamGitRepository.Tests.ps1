Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamDirectory.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamUserEntitlement.ps1"
. "$here/../../Source/Classes/VSTeamTeams.ps1"
. "$here/../../Source/Classes/VSTeamRepositories.ps1"
. "$here/../../Source/Classes/VSTeamReleaseDefinitions.ps1"
. "$here/../../Source/Classes/VSTeamTask.ps1"
. "$here/../../Source/Classes/VSTeamAttempt.ps1"
. "$here/../../Source/Classes/VSTeamEnvironment.ps1"
. "$here/../../Source/Classes/VSTeamRelease.ps1"
. "$here/../../Source/Classes/VSTeamReleases.ps1"
. "$here/../../Source/Classes/VSTeamBuild.ps1"
. "$here/../../Source/Classes/VSTeamBuilds.ps1"
. "$here/../../Source/Classes/VSTeamQueues.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitions.ps1"
. "$here/../../Source/Classes/VSTeamProject.ps1"
. "$here/../../Source/Classes/VSTeamGitRepository.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitionProcessPhaseStep.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitionProcessPhase.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinitionProcess.ps1"
. "$here/../../Source/Classes/VSTeamPool.ps1"
. "$here/../../Source/Classes/VSTeamQueue.ps1"
. "$here/../../Source/Classes/VSTeamBuildDefinition.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/Get-VSTeamQueue.ps1"
. "$here/../../Source/Public/Remove-VSTeamAccount.ps1"
. "$here/../../Source/Public/Get-VSTeamBuildDefinition.ps1"
. "$here/../../Source/Public/Get-VSTeamProject.ps1"
. "$here/../../Source/Classes/VSTeamGitRepository.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/$sut"
#endregion

$results = [PSCustomObject]@{
   value = [PSCustomObject]@{
      id            = ''
      url           = ''
      sshUrl        = ''
      remoteUrl     = ''
      defaultBranch = ''
      size          = 0
      name          = ''
      project       = [PSCustomObject]@{
         name        = 'Project'
         id          = 1
         description = ''
         url         = ''
         state       = ''
         revision    = ''
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
   size          = 0
   name          = ''
   project       = [PSCustomObject]@{
      name        = 'Project'
      id          = 1
      description = ''
      url         = ''
      state       = ''
      revision    = ''
      visibility  = ''
   }
}

Describe "VSTeamGitRepository" {
   ## Arrange
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

   ## If you don't call this and there is a default project in scope
   ## these tests will fail. The API can be called with or without
   ## a project and these tests are written to test without one. 
   Clear-DefaultProject

   . "$PSScriptRoot\mocks\mockProjectNameDynamicParam.ps1"

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

   Context 'Get-VSTeamGitRepository' {
      Context 'Services' {
         ## Arrange
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' }

         It 'no parameters should return all repos for all projects' {
            ## Act
            Get-VSTeamGitRepository

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/git/repositories?api-version=$([VSTeamVersions]::Git)"
            }
         }

         It 'by Id should return a single repo by id' {
            ## Act
            Get-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000000

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/git/repositories/00000000-0000-0000-0000-000000000000?api-version=$([VSTeamVersions]::Git)"
            }
         }

         It 'by name should return a single repo by name' {
            ## Act
            Get-VSTeamGitRepository -Name 'testRepo'

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/_apis/git/repositories/testRepo?api-version=$([VSTeamVersions]::Git)"
            }
         }

         It 'by id should throw' {
            ## Act / Assert
            { Get-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000101 } | Should Throw
         }

         It 'by name should throw' {
            ## Act / Assert
            { Get-VSTeamGitRepository -Name 'boom' } | Should Throw
         }
      }

      Context 'Server' {
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

         Mock _useWindowsAuthenticationOnPremise { return $true }

         It 'no parameters Should return Git repo' {
            ## Act
            Get-VSTeamGitRepository

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/git/repositories?api-version=$([VSTeamVersions]::Git)"
            }
         }

         It 'by Id should return a single repo by id' {
            ## Act
            Get-VSTeamGitRepository -id 00000000-0000-0000-0000-000000000000

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/git/repositories/00000000-0000-0000-0000-000000000000?api-version=$([VSTeamVersions]::Git)"
            }
         }

         It 'by name should return a single repo by name' {
            ## Act
            Get-VSTeamGitRepository -Name 'testRepo'

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/_apis/git/repositories/testRepo?api-version=$([VSTeamVersions]::Git)"
            }
         }
      }
   }
}