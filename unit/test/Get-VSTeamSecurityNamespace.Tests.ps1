Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/VSTeamSecurityNamespace.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Set-VSTeamAPIVersion.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe "VSTeamSecurityNamespace" {
   Context "Get-VSTeamSecurityNamespace" {
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      # to avoid the 
      # Cannot validate argument on parameter 'ProjectName'.
      # error when using test project names that do not really exist.
      Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

      Context 'Services' {
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'https://dev.azure.com/test' }

         $securityNamespaceListResult = Get-Content "$PSScriptRoot\sampleFiles\securityNamespaces.json" -Raw | ConvertFrom-Json
         $securityNamespaceSingleResult = Get-Content "$PSScriptRoot\sampleFiles\securityNamespace.single.json" -Raw | ConvertFrom-Json

         # You have to set the version or the api-version will not be added when versions = ''
         Set-VSTeamAPIVersion AzD
         [VSTeamVersions]::Core = '5.0'
      
         Mock Invoke-RestMethod { return $securityNamespaceListResult }
         Mock Invoke-RestMethod { return $securityNamespaceSingleResult } -ParameterFilter { $Uri -like "*58450c49-b02d-465a-ab12-59ae512d6531*" }

         It 'list should return namespaces' {
            Get-VSTeamSecurityNamespace
            # With PowerShell core the order of the query string is not the
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order.
            # The general string should look like this:
            # "https://vssps.dev.azure.com/test/_apis/graph/groups?api-version=$([VSTeamVersions]::Graph)&scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2"
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/securitynamespaces*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*"
            }
         }

         It 'by id should return a single namespace' {
            Get-VSTeamSecurityNamespace -Id 58450c49-b02d-465a-ab12-59ae512d6531

            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/securitynamespaces/58450c49-b02d-465a-ab12-59ae512d6531*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*"
            }
         }

         It 'by name should return namespace' {
            Get-VSTeamSecurityNamespace -Name "WorkItemTracking"
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/securitynamespaces*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*"
            }
         }

         It 'by list and localOnly should return namespaces' {
            Get-VSTeamSecurityNamespace -LocalOnly
            # With PowerShell core the order of the query string is not the
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order.
            # The general string should look like this:
            # "https://vssps.dev.azure.com/test/_apis/graph/groups?api-version=$([VSTeamVersions]::Graph)&scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2"
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/securitynamespaces*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Uri -like "*localOnly=true*"
            }
         }
      }

      Context "Server" {
         # Set the account to use for testing. A normal user would do this
         # using the Set-VSTeamAccount function.
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

         Mock _callAPI { throw 'Should not be called' } -Verifiable

         It 'should throw' {
            Set-VSTeamAPIVersion TFS2017

            { Get-VSTeamSecurityNamespace } | Should Throw
         }

         It '_callAPI should not be called' {
            Assert-MockCalled _callAPI -Exactly 0
         }
      }
   }
}