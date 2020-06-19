Set-StrictMode -Version Latest

Describe "VSTeamGroup" {
   BeforeAll {
      Import-Module SHiPS
   
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
   
      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/UncachedProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/UncachedProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamGroup.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDescriptor.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamDescriptor.ps1"
      . "$PSScriptRoot/../../Source/Public/Set-VSTeamAPIVersion.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }
   
   Context 'Get-VSTeamGroup' {
      Context 'Services' {
         BeforeAll {
            $groupListResult = Get-Content "$PSScriptRoot\sampleFiles\groups.json" -Raw | ConvertFrom-Json
            $projectResult = Get-Content "$PSScriptRoot\sampleFiles\projectResult.json" -Raw | ConvertFrom-Json
            $groupSingleResult = Get-Content "$PSScriptRoot\sampleFiles\groupsSingle.json" -Raw | ConvertFrom-Json
            $scopeResult = Get-Content "$PSScriptRoot\sampleFiles\descriptor.scope.TestProject.json" -Raw | ConvertFrom-Json

            # You have to set the version or the api-version will not be added when versions = ''
            Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Graph' }

            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

            Mock _supportsGraph

            Mock Invoke-RestMethod { return $groupListResult }
         }

         It 'by project should return groups' {
            Mock Get-VSTeamProject { return $projectResult } -Verifiable
            Mock Get-VSTeamDescriptor { return  [VSTeamDescriptor]::new($scopeResult) } -Verifiable

            Get-VSTeamGroup -ProjectName "Test Project Public"

            # With PowerShell core the order of the query string is not the
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order.
            # The general string should look like this:
            # "https://vssps.dev.azure.com/test/_apis/graph/groups?api-version=$(_getApiVersion Graph)&scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2"
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/groups*" -and
               $Uri -like "*api-version=$(_getApiVersion Graph)*" -and
               $Uri -like "*scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2*"
            }
         }

         It 'by scopeDescriptor should return groups' {
            Get-VSTeamGroup -ScopeDescriptor scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2

            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/groups*" -and
               $Uri -like "*api-version=$(_getApiVersion Graph)*" -and
               $Uri -like "*scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2*"
            }
         }

         It 'by subjectTypes should return groups' {
            Get-VSTeamGroup -SubjectTypes vssgp, aadgp

            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/groups*" -and
               $Uri -like "*api-version=$(_getApiVersion Graph)*" -and
               $Uri -like "*subjectTypes=vssgp,aadgp*"
            }
         }

         It 'by subjectTypes and scopeDescriptor should return groups' {
            Get-VSTeamGroup -ScopeDescriptor scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2 -SubjectTypes vssgp, aadgp

            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/groups*" -and
               $Uri -like "*api-version=$(_getApiVersion Graph)*" -and
               $Uri -like "*subjectTypes=vssgp,aadgp*" -and
               $Uri -like "*scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2*"
            }
         }

         It 'by descriptor should return the group' {
            Mock Invoke-RestMethod { return $groupSingleResult } -Verifiable

            Get-VSTeamGroup -GroupDescriptor 'vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x'

            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/groups/vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x*" -and
               $Uri -like "*api-version=$(_getApiVersion Graph)*"
            }
         }

         It 'Should throw' {
            Mock Invoke-RestMethod { throw 'Error' }
            { Get-VSTeamGroup -ProjectName Demo } | Should -Throw
         }

         It 'Should throw' {
            Mock Invoke-RestMethod { throw 'Error' }
            { Get-VSTeamGroup -GroupDescriptor } | Should -Throw
         }
      }
   }

   Context 'Server' {
      BeforeAll {
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }
         Mock _callAPI
      
         # Mock the call to Get-Projects by the dynamic parameter for ProjectName
         # if you don't _callAPI will be called for this an throw off the count
         # below.
         Mock _getProjects { return @() }

         Mock _getApiVersion { return 'TFS2017' }
         Mock _getApiVersion { return '' } -ParameterFilter { $Service -eq 'Graph' }

         # The Graph API is not supported on TFS
         Mock _supportsGraph { throw 'This account does not support the graph API.' }
      }

      It 'Should throw' {
         { Get-VSTeamGroup } | Should -Throw
      }

      It '_callAPI should not be called' {
         Should -Invoke _callAPI -Exactly -Times 0 -Scope Context
      }
   }
}

