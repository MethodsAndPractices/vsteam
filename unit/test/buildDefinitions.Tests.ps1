Set-StrictMode -Version Latest

Get-Module team | Remove-Module -Force
# Required for the dynamic parameter
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\buildDefinitions.psm1 -Force

InModuleScope buildDefinitions {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

   Describe 'BuildDefinitions' {
      . "$PSScriptRoot\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Show-VSTeamBuildDefinition by ID' {
         Mock _openOnWindows { }
         Mock _isOnWindows { return $true }

         it 'should return url for mine' {
            Show-VSTeamBuildDefinition -projectName project -Id 15

            Assert-MockCalled _openOnWindows -Exactly -Scope It -Times 1 -ParameterFilter { $command -eq 'https://test.visualstudio.com/project/_build/index?definitionId=15' }
         }
      }

      Context 'Show-VSTeamBuildDefinition Mine' {
         Mock _openOnWindows { }
         Mock _isOnWindows { return $true }

         it 'should return url for mine' {
            Show-VSTeamBuildDefinition -projectName project -Type Mine

            Assert-MockCalled _openOnWindows -Exactly -Scope It -Times 1 -ParameterFilter { $command -eq 'https://test.visualstudio.com/project/_build/index?_a=mine&path=%5c' }
         }
      }

      Context 'Show-VSTeamBuildDefinition Mine with path' {
         Mock _openOnWindows { }
         Mock _isOnWindows { return $true }

         it 'should return url for mine' {
            Show-VSTeamBuildDefinition -projectName project -path '\test'

            Assert-MockCalled _openOnWindows -Exactly -Scope It -Times 1 -ParameterFilter { $command -like 'https://test.visualstudio.com/project/_Build/index?_a=allDefinitions&path=%5Ctest' }
         }
      }

      Context 'Show-VSTeamBuildDefinition Mine with path missing \' {
         Mock _openOnWindows { }
         Mock _isOnWindows { return $true }

         it 'should return url for mine with \ added' {
            Show-VSTeamBuildDefinition -projectName project -path 'test'

            Assert-MockCalled _openOnWindows -Exactly -Scope It -Times 1 -ParameterFilter { $command -like 'https://test.visualstudio.com/project/_Build/index?_a=allDefinitions&path=%5Ctest' }
         }
      }

      Context 'Get-VSTeamBuildDefinition with no parameters' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  queue=@{}
                  _links=@{}
                  project=@{}
                  authoredBy=@{}
               }
            }}

         It 'should return build definitions' {
            Get-VSTeamBuildDefinition -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/project/_apis/build/definitions?api-version=$($VSTeamVersionTable.Build)" }
         }
      }

      Context 'Get-VSTeamBuildDefinition with type parameter' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  queue=@{}
                  _links=@{}
                  project=@{}
                  authoredBy=@{}
               }
            }}

         It 'should return build definitions by type' {
            Get-VSTeamBuildDefinition -projectName project -type build

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/project/_apis/build/definitions?api-version=$($VSTeamVersionTable.Build)&type=build" }
         }
      }

      Context 'Get-VSTeamBuildDefinition with filter parameter' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  queue=@{}
                  _links=@{}
                  project=@{}
                  authoredBy=@{}
               }
            }}

         It 'should return build definitions by filter' {
            Get-VSTeamBuildDefinition -projectName project -filter 'click*'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/project/_apis/build/definitions?api-version=$($VSTeamVersionTable.Build)&name=click*" }
         }
      }

      Context 'Get-VSTeamBuildDefinition with both parameters' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  queue=@{}
                  _links=@{}
                  project=@{}
                  authoredBy=@{}
               }
            }}

         It 'should return build definitions by filter' {
            Get-VSTeamBuildDefinition -projectName project -filter 'click*' -type build

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/project/_apis/build/definitions?api-version=$($VSTeamVersionTable.Build)&type=build&name=click*" }
         }
      }

      Context 'Add-VSTeamBuildDefinition' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  queue=@{}
                  _links=@{}
                  project=@{}
                  authoredBy=@{}
               }
            }}

         it 'Should add build' {
            Add-VSTeamBuildDefinition -projectName project -inFile 'builddef.json'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/definitions?api-version=$($VSTeamVersionTable.Build)" -and `
               $InFile -eq 'builddef.json' -and `
               $Method -eq 'Post'
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition by ID' {
         Mock Invoke-RestMethod { return @{
               queue=@{}
               _links=@{}
               project=@{}
               variables=@{}
               repository=@{}
               authoredBy=@{}
            }}

         It 'should return build definition' {
            Get-VSTeamBuildDefinition -projectName project -id 15

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/definitions/15?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }

      Context 'Get-VSTeamBuildDefinition with revision parameter' {
         Mock Invoke-RestMethod { return @{
               queue=@{}
               _links=@{}
               project=@{}
               authoredBy=@{}
            }}

         It 'should return build definitions by revision' {
            Get-VSTeamBuildDefinition -projectName project -id 16 -revision 1

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq "https://test.visualstudio.com/project/_apis/build/definitions/16?api-version=$($VSTeamVersionTable.Build)&revision=1" }
         }
      }

      Context 'Remove-VSTeamBuildDefinition' {
         Mock Invoke-RestMethod { return @{
               value=@{
                  queue=@{}
                  _links=@{}
                  project=@{}
                  authoredBy=@{}
               }
            }}

         It 'should delete build definition' {
            Remove-VSTeamBuildDefinition -projectName project -id 2 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Method -eq 'Delete' -and $Uri -eq "https://test.visualstudio.com/project/_apis/build/definitions/2?api-version=$($VSTeamVersionTable.Build)" }
         }
      }
   }
}