Set-StrictMode -Version Latest

Describe 'VSTeamRequest' {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/InvokeCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/UncachedProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/UncachedProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTask.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamAttempt.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamEnvironment.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamReleaseDefinitions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUserEntitlement.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRelease.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamReleases.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuild.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamTeams.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRepositories.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamQueues.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuilds.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamBuildDefinitions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"

      Mock _getProjects { return @() }
      Mock _hasProjectCacheExpired { return $true }
   }

   Context 'Invoke-VSTeamRequest Options' {
      BeforeAll {
         Mock Invoke-RestMethod
         Mock _getInstance { return 'https://dev.azure.com/test' }

         $projectResult = $(Get-Content "$PSScriptRoot\sampleFiles\projectResult.json" | ConvertFrom-Json)

         Mock _callAPI { return $projectResult } -ParameterFilter {
            $Area -eq 'projects' -and
            $id -eq 'testproject' -and
            $Version -eq "$(_getApiVersion Core)" -and
            $IgnoreDefaultProject -eq $true
         }
      }

      It 'options should call API' {
         Invoke-VSTeamRequest -Method Options -NoProject

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq "Options" -and
            $Uri -eq "https://dev.azure.com/test/_apis"
         }
      }

      It 'release should call API' {
         Invoke-VSTeamRequest -Area release -Resource releases -Id 1 -SubDomain vsrm -Version '4.1-preview' -ProjectName testproject -JSON

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/testproject/_apis/release/releases/1?api-version=4.1-preview"
         }
      }

      It 'AdditionalHeaders should call API' {
         Invoke-VSTeamRequest -Area release -Resource releases -Id 1 -SubDomain vsrm -Version '4.1-preview' -ProjectName testproject -JSON -AdditionalHeaders @{Test = "Test" }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Headers["Test"] -eq 'Test' -and
            $Uri -eq "https://vsrm.dev.azure.com/test/testproject/_apis/release/releases/1?api-version=4.1-preview"
         }
      }

      It 'by Product Id should call API with product id instead of name' {
         Invoke-VSTeamRequest -ProjectName testproject -UseProjectId -Area release -Resource releases -Id 1 -SubDomain vsrm -Version '4.1-preview'

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -eq "https://vsrm.dev.azure.com/test/010d06f0-00d5-472a-bb47-58947c230876/_apis/release/releases/1?api-version=4.1-preview"
         }
      }
   }
}