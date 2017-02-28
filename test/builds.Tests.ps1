Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
Import-Module $PSScriptRoot\..\src\queues.psm1 -Force
Import-Module $PSScriptRoot\..\src\builds.psm1 -Force

InModuleScope builds {
   $env:TEAM_ACCT = 'https://test.visualstudio.com'

   # Just a shell for the nest dynamic parameters
   # Used as Mock for calls below. We can't use normal
   # Mock because the module where is lives is not loaded.
   function Get-BuildDefinition {
      return new-object psobject -Property @{
         id=2
         name='MyBuildDef'
      }
   }

   Describe 'Builds' {
      . "$PSScriptRoot\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Get Builds with no parameters' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  logs=@{}
                  queue=@{}
                  _links=@{}
                  project=@{}
                  repository=@{}
                  requestedFor=@{}
                  orchestrationPlan=@{}
                  definition=@{}
                  lastChangedBy=@{}
                  requestedBy=@{}
               }
            }
         }

         It 'should return builds' {
            Get-Build -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/project/_apis/build/builds?api-version=2.0' }
         }
      }

      Context 'Get Builds with Top parameter' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  logs=@{}
                  queue=@{}
                  _links=@{}
                  project=@{}
                  repository=@{}
                  requestedFor=@{}
                  orchestrationPlan=@{}
                  definition=@{}
                  lastChangedBy=@{}
                  requestedBy=@{}
               }
            }
         }

         It 'should return top builds' {
            Get-Build -projectName project -top 1

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/project/_apis/build/builds?api-version=2.0&$top=1' }
         }
      }

      Context 'Get Build build by id' {
         Mock Invoke-RestMethod { return @{
               logs=@{}
               queue=@{pool=''}
               _links=@{}
               project=@{}
               repository=@{}
               requestedFor=@{}
               orchestrationPlan=@{}
               definition=@{}
               lastChangedBy=@{}
               requestedBy=@{}
            }
         }

         It 'should return top builds' {
            Get-Build -projectName project -id 1

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq 'https://test.visualstudio.com/project/_apis/build/builds/1?api-version=2.0' }
         }
      }

      Context 'Add-Build with no parameters' {
         Mock Invoke-RestMethod { return @{
               logs=@{}
               queue=@{}
               _links=@{}
               project=@{}
               repository=@{}
               requestedFor=@{}
               orchestrationPlan=@{}
               definition=@{}
               lastChangedBy=@{}
               requestedBy=@{}
            }
         }

         It 'should add build' {
            Add-Build -ProjectName project -BuildDefinition 'MyBuildDef'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Body -eq '{"definition": {"id": 2}}' -and
               $Uri -eq 'https://test.visualstudio.com/project/_apis/build/builds?api-version=2.0'
            }
         }
      }

      Context 'Remove-Build' {
         Mock Invoke-RestMethod -UserAgent (_getUserAgent)

         It 'should delete build' {
            Remove-Build -projectName project -id 2 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq 'https://test.visualstudio.com/project/_apis/build/builds/2?api-version=2.0'
            }
         }
      }
   }
}