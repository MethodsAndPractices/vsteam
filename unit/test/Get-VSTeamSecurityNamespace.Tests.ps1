Set-StrictMode -Version Latest

Describe "VSTeamSecurityNamespace" {
   BeforeAll {
      Import-Module SHiPS

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamSecurityNamespace.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Set-VSTeamAPIVersion.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   }

   Context "Get-VSTeamSecurityNamespace" {
      BeforeAll {
         # Mock the call to Get-Projects by the dynamic parameter for ProjectName
         # to avoid the
         # Cannot validate argument on parameter 'ProjectName'.
         # error when using test project names that do not really exist.
         Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }
      }

      Context 'Services' {
         BeforeAll {
            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'https://dev.azure.com/test' }
            Mock _supportsSecurityNamespace { return $true }

            $securityNamespaceListResult = Get-Content "$PSScriptRoot\sampleFiles\securityNamespaces.json" -Raw | ConvertFrom-Json
            $securityNamespaceSingleResult = Get-Content "$PSScriptRoot\sampleFiles\securityNamespace.single.json" -Raw | ConvertFrom-Json

            # You have to set the version or the api-version will not be added when versions = ''
            Mock _getApiVersion { return 'AzD' }
            Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }

            Mock Invoke-RestMethod { return $securityNamespaceListResult }
            Mock Invoke-RestMethod { return $securityNamespaceSingleResult } -ParameterFilter { $Uri -like "*58450c49-b02d-465a-ab12-59ae512d6531*" }
         }

         It 'list should return namespaces' {
            Get-VSTeamSecurityNamespace
            # With PowerShell core the order of the query string is not the
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order.
            # The general string should look like this:
            # "https://vssps.dev.azure.com/test/_apis/graph/groups?api-version=$(_getApiVersion Graph)&scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2"
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/securitynamespaces*" -and
               $Uri -like "*api-version=$(_getApiVersion Core)*"
            }
         }

         It 'by id should return a single namespace' {
            Get-VSTeamSecurityNamespace -Id 58450c49-b02d-465a-ab12-59ae512d6531

            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/securitynamespaces/58450c49-b02d-465a-ab12-59ae512d6531*" -and
               $Uri -like "*api-version=$(_getApiVersion Core)*"
            }
         }

         It 'by name should return namespace' {
            Get-VSTeamSecurityNamespace -Name "WorkItemTracking"
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/securitynamespaces*" -and
               $Uri -like "*api-version=$(_getApiVersion Core)*"
            }
         }

         It 'by list and localOnly should return namespaces' {
            Get-VSTeamSecurityNamespace -LocalOnly
            # With PowerShell core the order of the query string is not the
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order.
            # The general string should look like this:
            # "https://vssps.dev.azure.com/test/_apis/graph/groups?api-version=$(_getApiVersion Graph)&scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2"
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/securitynamespaces*" -and
               $Uri -like "*api-version=$(_getApiVersion Core)*" -and
               $Uri -like "*localOnly=true*"
            }
         }
      }

      Context "Server" {
         BeforeAll {
            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

            Mock _callAPI { throw 'Should not be called' } -Verifiable
            Mock _getApiVersion { return 'TFS2017' }
            Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
         }

         It 'should throw' {
            { Get-VSTeamSecurityNamespace } | Should -Throw
         }

         It '_callAPI should not be called' {
            Should -Invoke _callAPI -Exactly 0
         }
      }
   }
}