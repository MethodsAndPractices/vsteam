Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
# Required for the dynamic parameter
Import-Module $PSScriptRoot\..\..\src\buildDefinitions.psm1 -Force

InModuleScope buildDefinitions {
   $env:TEAM_ACCT = 'https://test.visualstudio.com'

   Describe 'BuildDefinitions' {
      . "$PSScriptRoot\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Get-BuildDefinition with no parameters' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  queue=@{}
                  _links=@{}
                  project=@{}
                  authoredBy=@{}
               }
            }}

         It 'should return build definitions' {
            Get-BuildDefinition -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/project/_apis/build/definitions?api-version=2.0' }
         }
      }

      Context 'Get-BuildDefinition with type parameter' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  queue=@{}
                  _links=@{}
                  project=@{}
                  authoredBy=@{}
               }
            }}

         It 'should return build definitions by type' {
            Get-BuildDefinition -projectName project -type build

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/project/_apis/build/definitions?api-version=2.0&type=build' }
         }
      }

      Context 'Get-BuildDefinition with filter parameter' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  queue=@{}
                  _links=@{}
                  project=@{}
                  authoredBy=@{}
               }
            }}

         It 'should return build definitions by filter' {
            Get-BuildDefinition -projectName project -filter 'click*'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/project/_apis/build/definitions?api-version=2.0&name=click*' }
         }
      }

      Context 'Get-BuildDefinition with both parameters' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  queue=@{}
                  _links=@{}
                  project=@{}
                  authoredBy=@{}
               }
            }}

         It 'should return build definitions by filter' {
            Get-BuildDefinition -projectName project -filter 'click*' -type build

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/project/_apis/build/definitions?api-version=2.0&type=build&name=click*' }
         }
      }

      Context 'Add-BuildDefinition' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  queue=@{}
                  _links=@{}
                  project=@{}
                  authoredBy=@{}
               }
            }}

         it 'Should add build' {
            Add-BuildDefinition -projectName project -inFile 'builddef.json'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq 'https://test.visualstudio.com/project/_apis/build/definitions?api-version=2.0' -and `
               $InFile -eq 'builddef.json' -and `
               $Method -eq 'Post'
            }
         }
      }

      Context 'Get-BuildDefinition by ID' {
         Mock Invoke-RestMethod { return @{
               queue=@{}
               _links=@{}
               project=@{}
               variables=@{}
               repository=@{}
               authoredBy=@{}
            }}

         It 'should return build definition' {
            Get-BuildDefinition -projectName project -id 15

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq 'https://test.visualstudio.com/project/_apis/build/definitions/15?api-version=2.0'
            }
         }
      }

      Context 'Get-BuildDefinition with revision parameter' {
         Mock Invoke-RestMethod { return @{
               queue=@{}
               _links=@{}
               project=@{}
               authoredBy=@{}
            }}

         It 'should return build definitions by revision' {
            Get-BuildDefinition -projectName project -id 16 -revision 1

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/project/_apis/build/definitions/16?api-version=2.0&revision=1' }
         }
      }

      Context 'Remove-BuildDefinition' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  queue=@{}
                  _links=@{}
                  project=@{}
                  authoredBy=@{}
               }
            }}

         It 'should delete build definition' {
            Remove-BuildDefinition -projectName project -id 2 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -eq 'https://test.visualstudio.com/project/_apis/build/definitions/2?api-version=2.0' }
         }
      }
   }
}