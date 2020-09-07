Set-StrictMode -Version Latest

Describe "VSTeamDescriptor" {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Get-VSTeamDescriptor' {
      Context 'Services' {
         BeforeAll {
            ## Arrange
            Mock _supportsGraph

            # Set the account to use for testing. A normal user would do this
            # using the Set-VSTeamAccount function.
            Mock _getInstance { return 'https://dev.azure.com/test' }
            
            Mock Invoke-RestMethod { Open-SampleFile 'descriptor.scope.TestProject.json' }
            
            # You have to set the version or the api-version will not be added when versions = ''
            Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Graph' }
         }

         It 'by StorageKey Should return groups' {
            ## Act
            Get-VSTeamDescriptor -StorageKey '010d06f0-00d5-472a-bb47-58947c230876'

            ## Assert
            Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Uri -eq "https://vssps.dev.azure.com/test/_apis/graph/descriptors/010d06f0-00d5-472a-bb47-58947c230876?api-version=$(_getApiVersion Graph)"
            }
         }
      }

      Context 'Server' {
         BeforeAll {
            ## Arrange
            # TFS 2017 does not support this feature
            Mock _callAPI { throw 'Should not be called' } -Verifiable

            # It is not supported on 2017
            Mock _getApiVersion { return 'TFS2017' }
            Mock _getApiVersion { return '' } -ParameterFilter { $Service -eq 'Graph' }
         }

         It 'Should throw' {
            ## Act / Assert
            { Get-VSTeamDescriptor -StorageKey '010d06f0-00d5-472a-bb47-58947c230876' } | Should -Throw
         }

         It 'should not call _callAPI' {
            Should -Invoke _callAPI -Exactly 0
         }
      }
   }
}