Set-StrictMode -Version Latest

Describe "VSTeamSecurityNamespace" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context "Get-VSTeamSecurityNamespace" {
      Context 'Services' {
         BeforeAll {
            ## Arrange
            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'https://dev.azure.com/test' }
            Mock _supportsSecurityNamespace { return $true }

            # You have to set the version or the api-version will not be added when versions = ''
            Mock _getApiVersion { return 'AzD' }
            Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }

            Mock Invoke-RestMethod { Open-SampleFile 'securityNamespaces.json' }
            Mock Invoke-RestMethod { Open-SampleFile 'securityNamespace.single.json' } -ParameterFilter {
               $Uri -like "*58450c49-b02d-465a-ab12-59ae512d6531*" 
            }
         }

         It 'list should return namespaces' {
            ## Act
            Get-VSTeamSecurityNamespace

            ## Assert
            # With PowerShell core the order of the query string is not the
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order.
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/securitynamespaces*" -and
               $Uri -like "*api-version=$(_getApiVersion Core)*"
            }
         }

         It 'by id should return a single namespace' {
            ## Act
            Get-VSTeamSecurityNamespace -Id 58450c49-b02d-465a-ab12-59ae512d6531

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/securitynamespaces/58450c49-b02d-465a-ab12-59ae512d6531*" -and
               $Uri -like "*api-version=$(_getApiVersion Core)*"
            }
         }

         It 'by name should return namespace' {
            ## Act
            Get-VSTeamSecurityNamespace -Name "WorkItemTracking"
       
            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -like "https://dev.azure.com/test/_apis/securitynamespaces*" -and
               $Uri -like "*api-version=$(_getApiVersion Core)*"
            }
         }

         It 'by list and localOnly should return namespaces' {
            ## Act
            Get-VSTeamSecurityNamespace -LocalOnly
            
            ## Assert
            # With PowerShell core the order of the query string is not the
            # same from run to run!  So instead of testing the entire string
            # matches I have to search for the portions I expect but can't
            # assume the order.          
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
            ## Act / Assert
            { Get-VSTeamSecurityNamespace } | Should -Throw
         }

         It '_callAPI should not be called' {
            ## Assert
            Should -Invoke _callAPI -Exactly 0
         }
      }
   }
}