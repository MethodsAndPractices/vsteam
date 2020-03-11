Set-StrictMode -Version Latest

InModuleScope VSTeam {
   Describe "SecurityNamespace TFS Errors" {
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable
   
      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      Context 'Get-VSTeamSecurityNamespace' {
         Mock _callAPI { throw 'Should not be called' } -Verifiable

         It 'Should throw' {
            Set-VSTeamAPIVersion TFS2017

            { Get-VSTeamSecurityNamespace } | Should Throw
         }

         It '_callAPI should not be called' {
            Assert-MockCalled _callAPI -Exactly 0
         }
      }
   }

   Describe 'SecurityNamespace VSTS' {
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

      $securityNamespaceListResult = Get-Content "$PSScriptRoot\sampleFiles\securityNamespaces.json" -Raw | ConvertFrom-Json
      $securityNamespaceSingleResult = Get-Content "$PSScriptRoot\sampleFiles\securityNamespace.single.json" -Raw | ConvertFrom-Json

      # You have to set the version or the api-version will not be added when
      # [VSTeamVersions]::Core = ''
      Set-VSTeamAPIVersion AzD
      [VSTeamVersions]::Core = '5.0'
      
      Context 'Get-VSTeamSecurityNamespace list' {
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $securityNamespaceListResult
         } -Verifiable

         Get-VSTeamSecurityNamespace

         It 'Should return namespaces' {
            # With PowerShell core the order of the query string is not the
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order.
            # The general string should look like this:
            # "https://vssps.dev.azure.com/test/_apis/graph/groups?api-version=$([VSTeamVersions]::Graph)&scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2"
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/securitynamespaces*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*"
            }
         }
      }

      Context 'Get-VSTeamSecurityNamespace by id' {
         Mock Invoke-RestMethod { return $securityNamespaceSingleResult } -Verifiable

         Get-VSTeamSecurityNamespace -Id 58450c49-b02d-465a-ab12-59ae512d6531

         It 'Should return namespaces' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/securitynamespaces/58450c49-b02d-465a-ab12-59ae512d6531*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*"
            }
         }
      }

      Context 'Get-VSTeamSecurityNamespace by name' {
         Mock Invoke-RestMethod { return $securityNamespaceListResult } -Verifiable

         Get-VSTeamSecurityNamespace -Name "WorkItemTracking"

         It 'Should return namespaces' {
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/securitynamespaces*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*"
            }
         }
      }

      Context 'Get-VSTeamSecurityNamespace by list and localOnly' {
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args

            return $securityNamespaceListResult
         } -Verifiable

         Get-VSTeamSecurityNamespace -LocalOnly

         It 'Should return namespaces' {
            # With PowerShell core the order of the query string is not the
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order.
            # The general string should look like this:
            # "https://vssps.dev.azure.com/test/_apis/graph/groups?api-version=$([VSTeamVersions]::Graph)&scopeDescriptor=scp.ZGU5ODYwOWEtZjRiMC00YWEzLTgzOTEtODI4ZDU2MDI0MjU2"
            Assert-MockCalled Invoke-RestMethod -Exactly 1 -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/securitynamespaces*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Core)*" -and
               $Uri -like "*localOnly=true*"
            }
         }
      }

      Context 'Get-VSTeamSecurityNamespace throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Get-VSTeamSecurityNamespace } | Should Throw
         }
      }

      Context 'Get-VSTeamSecurityNamespace by id throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Get-VSTeamSecurityNamespace -Id 58450c49-b02d-465a-ab12-59ae512d6531  } | Should Throw
         }
      }

      Context 'Get-VSTeamSecurityNamespace by name throws' {
         Mock Invoke-RestMethod { throw 'Error' }

         It 'Should throw' {
            { Get-VSTeamSecurityNamespace -Name "WorkItemTracking" } | Should Throw
         }
      }
   }
}