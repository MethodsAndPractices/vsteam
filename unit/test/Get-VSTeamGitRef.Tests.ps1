Set-StrictMode -Version Latest

Describe "VSTeamGitRef" {
   BeforeAll {
      Import-Module SHiPS
   
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
   
      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamUserEntitlement.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamRef.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   
      ## Arrange
      # Make sure the project name is valid. By returning an empty array
      # all project names are valid. Otherwise, you name you pass for the
      # project in your commands must appear in the list.
      Mock _getProjects { return @() }
      
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Git' }

      $results = [PSCustomObject]@{
         value = [PSCustomObject]@{
            objectId = '6f365a7143e492e911c341451a734401bcacadfd'
            name     = 'refs/heads/master'
            creator  = [PSCustomObject]@{
               displayName = 'Microsoft.VisualStudio.Services.TFS'
               id          = '1'
               uniqueName  = 'some@email.com'
            }
         }
      }
   
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

      Mock Invoke-RestMethod { return $results }
      Mock Invoke-RestMethod { throw [System.Net.WebException] "Test Exception." } -ParameterFilter {
         $Uri -like "*00000000-0000-0000-0000-000000000001*"
      } 
   }

   Context 'Get-VSTeamGitRef' {
      It 'Should return a single ref by id' {
         ## Act
         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000
         
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/Test/_apis/git/repositories/00000000-0000-0000-0000-000000000000/refs?api-version=$(_getApiVersion Git)"
         }
      }

      It 'with Filter should return a single ref with filter' {
         ## Act
         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -Filter "refs/heads"
         
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*filter=refs*"
         }
      }

      It 'with FilterContains should return a single ref' {
         ## Act
         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -FilterContains "test"
         
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*filterContains=test"
         }
      }

      It 'Should return a single ref' {
         ## Act
         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -Top 100
         
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*`$top=100"
         }
      }
      
      It 'with ContinuationToken should return a single ref' {
         ## Act
         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -ContinuationToken "myToken"
         
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*continuationToken=myToken"
         }
      }

      It 'with Filter, FilterContains, Top should return a single ref' {
         ## Act
         Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000000 -Filter "/refs/heads" -FilterContains "test" -Top 500
         
         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri -like "*filter=/refs/heads*" -and
            $Uri -like "*`$top=500*" -and
            $Uri -like "*filterContains=test*"
         }
      }

      It 'by id throws should return a single repo by id' {
         ## Act / Assert
         { Get-VSTeamGitRef -ProjectName Test -RepositoryId 00000000-0000-0000-0000-000000000001 } | Should -Throw
      }
   }
}