Set-StrictMode -Version Latest

# Remove any loaded version of this module so only the files
# imported below are being tested.
Get-Module VSTeam | Remove-Module -Force

# Load the modules we want to test and any dependencies
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\queues.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\builds.psm1 -Force

# The InModuleScope command allows you to perform white-box unit testing on the
# internal (non-exported) code of a Script Module.
InModuleScope builds {

   # Just in case it was loaded. If we don't do 
   # this some test may fail
   Remove-VSTeamAccount | Out-Null

   # Sample result of a single build
   $singleResult = [PSCustomObject]@{
      logs              = [PSCustomObject]@{}
      queue             = [PSCustomObject]@{}
      _links            = [PSCustomObject]@{}
      project           = [PSCustomObject]@{}
      repository        = [PSCustomObject]@{}
      requestedFor      = [PSCustomObject]@{}
      orchestrationPlan = [PSCustomObject]@{}
      definition        = [PSCustomObject]@{}
      lastChangedBy     = [PSCustomObject]@{}
      requestedBy       = [PSCustomObject]@{}
   }

   # Sample result for list of builds
   $results = [PSCustomObject]@{
      value = [PSCustomObject]@{
         logs              = [PSCustomObject]@{}
         queue             = [PSCustomObject]@{}
         _links            = [PSCustomObject]@{}
         project           = [PSCustomObject]@{}
         repository        = [PSCustomObject]@{}
         requestedFor      = [PSCustomObject]@{}
         orchestrationPlan = [PSCustomObject]@{}
         definition        = [PSCustomObject]@{}
         lastChangedBy     = [PSCustomObject]@{}
         requestedBy       = [PSCustomObject]@{}
      }
   }

   # Just a shell for the nested dynamic parameters
   # Used as Mock for calls below. We can't use normal
   # Mock because the module where it lives is not loaded.
   function Get-VSTeamBuildDefinition {
      return new-object psobject -Property @{
         id       = 2
         name     = 'MyBuildDef'
         fullName = 'folder\MyBuildDef'
      }
   }

   Describe 'Builds VSTS' {
      # Load the mocks to create the project name dynamic parameter
      . "$PSScriptRoot\mockProjectNameDynamicParamNoPSet.ps1"

      # Set the account to use for testing. A normal user would do this
      # using the Add-VSTeamAccount function.
      $VSTeamVersionTable.Account = 'https://test.visualstudio.com'

      Context 'Update Build keep forever' {
         Mock Invoke-RestMethod

         Update-VSTeamBuild -projectName project -id 1 -KeepForever $true -Force

         It 'should post changes' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter { 
               $Method -eq 'Patch' -and 
               $Body -eq '{"keepForever": true}' -and 
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/builds/1?api-version=$($VSTeamVersionTable.Build)" }
         }
      }

      Context 'Show-VSTeamBuild by ID' {
         Mock _showInBrowser { }

         it 'should return url for mine' {
            Show-VSTeamBuild -projectName project -Id 15

            Assert-MockCalled _showInBrowser -Exactly -Scope It -Times 1 -ParameterFilter { $url -eq 'https://test.visualstudio.com/project/_build/index?buildId=15' }
         }
      }

      Context 'Get Build Log with build id' {
         Mock Invoke-RestMethod { return @{ count = 4 } } -Verifiable -ParameterFilter {
            $Uri -eq "https://test.visualstudio.com/project/_apis/build/builds/1/logs/?api-version=$($VSTeamVersionTable.Build)" 
         }
         Mock Invoke-RestMethod { return @{ value = @{} } } -Verifiable -ParameterFilter {
            $Uri -eq "https://test.visualstudio.com/project/_apis/build/builds/1/logs/3?api-version=$($VSTeamVersionTable.Build)"
         }
         Mock Invoke-RestMethod { throw 'Invoke-RestMethod called with wrong URL' }

         Get-VSTeamBuildLog -projectName project -Id 1

         It 'Should return full log' {
            Assert-VerifiableMock
         }
      }

      Context 'Get Build Log with build id and index' {
         Mock Invoke-RestMethod { return @{ value = @{} } } -Verifiable -ParameterFilter { $Uri -eq "https://test.visualstudio.com/project/_apis/build/builds/1/logs/2?api-version=$($VSTeamVersionTable.Build)" }
         Mock Invoke-RestMethod { throw 'Invoke-RestMethod called with wrong URL' }

         Get-VSTeamBuildLog -projectName project -Id 1 -Index 2

         It 'Should return full log' {
            Assert-VerifiableMock
         }
      }

      Context 'Get Builds with no parameters' {
         Mock Invoke-RestMethod { return $results }

         It 'should return builds' {
            Get-VSTeamBuild -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/builds/?api-version=$($VSTeamVersionTable.Build)" 
            }
         }
      }

      Context 'Get Builds with Top parameter' {
         Mock Invoke-RestMethod { return $results }

         It 'should return top builds' {
            Get-VSTeamBuild -projectName project -top 1

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/builds/?api-version=$($VSTeamVersionTable.Build)&`$top=1" 
            }
         }
      }

      Context 'Get Build build by id' {
         Mock Invoke-RestMethod { return $singleResult }

         Get-VSTeamBuild -projectName project -id 1

         It 'should return top builds' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/builds/1?api-version=$($VSTeamVersionTable.Build)" 
            }
         }
      }

      Context 'Add-VSTeamBuild by name' {
         Mock Invoke-RestMethod { return $singleResult }

         It 'should add build' {
            Add-VSTeamBuild -ProjectName project -BuildDefinitionName 'folder\MyBuildDef'

            # Call to queue build.
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               ($Body | ConvertFrom-Json).definition.id -eq 2 -and
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/builds/?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }

      Context 'Add-VSTeamBuild by id' {
         Mock Invoke-RestMethod { 
            return $singleResult 
         }

         It 'should add build' {
            Add-VSTeamBuild -ProjectName project -BuildDefinitionId 2

            # Call to queue build.
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               ($Body | ConvertFrom-Json).definition.id -eq 2 -and
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/builds/?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }

      Context 'Add-VSTeamBuild with parameters' {
         Mock Invoke-RestMethod { 
            return $singleResult 
         }

         It 'should add build' {
            Add-VSTeamBuild -ProjectName project -BuildDefinitionId 2 -BuildParameters @{'system.debug'='true'}

            # Call to queue build.
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               ($Body | ConvertFrom-Json).definition.id -eq 2 -and
               (($Body | ConvertFrom-Json).parameters | ConvertFrom-Json).'system.debug' -eq 'true' -and
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/builds/?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }

      Context 'Remove-VSTeamBuild' {

         # Arrange
         Mock Invoke-RestMethod

         # Act
         Remove-VSTeamBuild -projectName project -id 2 -Force

         It 'should delete build' {

            # Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/builds/2?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }

      Context 'Add-VSTeamBuildTag' {
         Mock Invoke-RestMethod
         $inputTags = "Test1", "Test2", "Test3"

         It 'should add tags to Build' {
            Add-VSTeamBuildTag -ProjectName project -id 2 -Tags $inputTags

            foreach ($inputTag in $inputTags) {
               Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                  $Method -eq 'Put' -and
                  $Uri -eq "https://test.visualstudio.com/project/_apis/build/builds/2/tags/?api-version=$($VSTeamVersionTable.Build)" + "&tag=$inputTag"
               }
            }
         }
      }

      Context 'Remove-VSTeamBuildTag' {
         Mock Invoke-RestMethod {
            return @{ value = $null }
         }
         [string[]] $inputTags = "Test1", "Test2", "Test3"

         It 'should add tags to Build' {
            Remove-VSTeamBuildTag -ProjectName project -id 2 -Tags $inputTags

            foreach ($inputTag in $inputTags) {
               Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                  $Method -eq 'Delete' -and
                  $Uri -eq "https://test.visualstudio.com/project/_apis/build/builds/2/tags/?api-version=$($VSTeamVersionTable.Build)" + "&tag=$inputTag"
               }
            }
         }
      }

      Context 'Get-VSTeamBuildTag calls correct Url' {
         Mock Invoke-RestMethod {
            return @{ value = 'Tag1', 'Tag2'}
         }

         It 'should get all Build Tags for the Build.' {
            Get-VSTeamBuildTag -projectName project -id 2

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/builds/2/tags/?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }

      Context 'Get-VSTeamBuildTag returns correct data' {
         $tags = 'Tag1', 'Tag2'
         Mock Invoke-RestMethod {
            return @{ value = $tags}
         }

         It 'should get all Build Tags for the Build.' {
            $returndata = Get-VSTeamBuildTag -projectName project -id 2

            Compare-Object $tags  $returndata |
               Should Be $null
         }
      }

      Context "Get-VSTeamBuildArtifact calls correct Url" {
         Mock Invoke-RestMethod { return [PSCustomObject]@{
               value = [PSCustomObject]@{
                  id       = 150
                  name     = "Drop"
                  resource = [PSCustomObject]@{
                     type       = "filepath"
                     data       = "C:\Test"
                     properties = [PSCustomObject]@{ }
                  }
               }
            }
         }

         Get-VSTeamBuildArtifact -projectName project -id 2

         It 'should return the build artifact data' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Uri -eq "https://test.visualstudio.com/project/_apis/build/builds/2/artifacts/?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }
   }

   Describe 'Builds TFS' {
      . "$PSScriptRoot\mockProjectNameDynamicParamNoPSet.ps1"

      Mock _useWindowsAuthenticationOnPremise { return $true }

      $VSTeamVersionTable.Account = 'http://localhost:8080/tfs/defaultcollection'

      Context 'Get Build Log with index on TFS local Auth' {
         Mock Invoke-RestMethod { return @{ value = @{} } } -Verifiable -ParameterFilter { $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1/logs/2?api-version=$($VSTeamVersionTable.Build)" }
         Mock Invoke-RestMethod { throw 'Invoke-RestMethod called with wrong URL' }

         Get-VSTeamBuildLog -projectName project -Id 1 -Index 2

         It 'Should return full log' {
            Assert-VerifiableMock
         }
      }

      Context 'Get Builds with no parameters on TFS local Auth' {
         Mock Invoke-RestMethod { return $results }

         It 'should return builds' {
            Get-VSTeamBuild -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }

      Context 'Get Build by id on TFS local Auth' {
         Mock Invoke-RestMethod { return $singleResult }

         It 'should return builds' {
            Get-VSTeamBuild -projectName project -id 2

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/2?api-version=$($VSTeamVersionTable.Build)" }
         }
      }

      Context 'Get Build Log on TFS local Auth' {
         Mock Invoke-RestMethod { return @{ count = 4 } } -Verifiable -ParameterFilter { 
            $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1/logs/?api-version=$($VSTeamVersionTable.Build)"
         }
         Mock Invoke-RestMethod { return @{ value = @{} } } -Verifiable -ParameterFilter {
            $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1/logs/3?api-version=$($VSTeamVersionTable.Build)"
         }
         Mock Invoke-RestMethod { throw 'Invoke-RestMethod called with wrong URL' }

         Get-VSTeamBuildLog -projectName project -Id 1

         It 'Should return full log' {
            Assert-VerifiableMock
         }
      }

      Context "Get-VSTeamBuildArtifact calls correct Url on TFS local Auth" {
         Mock Invoke-RestMethod {
             return [PSCustomObject]@{
               value = [PSCustomObject]@{
                  id       = 150
                  name     = "Drop"
                  resource = [PSCustomObject]@{
                     type       = "filepath"
                     data       = "C:\Test"
                     properties = [PSCustomObject]@{ }
                  }
               }
            }
         }

         Get-VSTeamBuildArtifact -projectName project -id 2

         It 'should return the build artifact data' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/2/artifacts/?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }

      Context 'Get-VSTeamBuildTag returns correct data on TFS local Auth' {
         $tags = 'Tag1', 'Tag2'
         Mock Invoke-RestMethod {
            return @{ value = $tags}
         }

         It 'should get all Build Tags for the Build.' {
            $returndata = Get-VSTeamBuildTag -projectName project -id 2

            Compare-Object $tags  $returndata |
               Should Be $null
         }
      }

      Context 'Add-VSTeamBuildTag on TFS local Auth' {
         Mock Invoke-RestMethod
         $inputTags = "Test1", "Test2", "Test3"

         It 'should add tags to Build' {
            Add-VSTeamBuildTag -ProjectName project -id 2 -Tags $inputTags

            foreach ($inputTag in $inputTags) {
               Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                  $Method -eq 'Put' -and
                  $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/2/tags/?api-version=$($VSTeamVersionTable.Build)" + "&tag=$inputTag"
               }
            }
         }
      }

      Context 'Remove-VSTeamBuild on TFS local Auth' {
         Mock Invoke-RestMethod

         It 'should delete build' {
            Remove-VSTeamBuild -projectName project -id 2 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Delete' -and
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/2?api-version=$($VSTeamVersionTable.Build)"
            }
         }
      }

      Context 'Add-VSTeamBuild by id on TFS local Auth' {
         Mock Get-VSTeamQueue { return [PSCustomObject]@{
               name = "MyQueue"
               id   = 3
            }
         }
         Mock Get-VSTeamBuildDefinition { return @{ fullname = "MyBuildDef" } }

         Mock Invoke-RestMethod { return $singleResult } -Verifiable -ParameterFilter {
            ($Body | ConvertFrom-Json).definition.id -eq 2 -and
            ($Body | ConvertFrom-Json).queue.id -eq 3 -and
            $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/?api-version=$($VSTeamVersionTable.Build)"
         }

         Mock Invoke-RestMethod { throw 'Invoke-RestMethod called with wrong URL' }

         $Global:PSDefaultParameterValues["*:projectName"] = 'Project'

         Add-VSTeamBuild -projectName project -BuildDefinitionId 2 -QueueName MyQueue

         It 'should add build' {
            # Call to queue build.
            Assert-VerifiableMock
         }

         AfterAll {
            $Global:PSDefaultParameterValues.Remove("*:projectName")
         }
      }

      Context 'Add-VSTeamBuild with parameters on TFS local Auth' {
         Mock Get-VSTeamQueue { return [PSCustomObject]@{
               name = "MyQueue"
               id   = 3
            }
         }
         Mock Get-VSTeamBuildDefinition { return @{ fullname = "MyBuildDef" } }

         Mock Invoke-RestMethod { return $singleResult } -Verifiable -ParameterFilter {
            ($Body | ConvertFrom-Json).definition.id -eq 2 -and
            ($Body | ConvertFrom-Json).queue.id -eq 3 -and
            (($Body | ConvertFrom-Json).parameters | ConvertFrom-Json).'system.debug' -eq 'true' -and
            $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/?api-version=$($VSTeamVersionTable.Build)"
         }

         Mock Invoke-RestMethod { throw 'Invoke-RestMethod called with wrong URL' }

         $Global:PSDefaultParameterValues["*:projectName"] = 'Project'

         Add-VSTeamBuild -projectName project -BuildDefinitionId 2 -QueueName MyQueue -BuildParameters @{'system.debug'='true'}

         It 'should add build' {
            # Call to queue build.
            Assert-VerifiableMock
         }

         AfterAll {
            $Global:PSDefaultParameterValues.Remove("*:projectName")
         }
      }

      Context 'Remove-VSTeamBuildTag' {
         Mock Invoke-RestMethod {
            return @{ value = $null }
         }
         [string[]] $inputTags = "Test1", "Test2", "Test3"

         It 'should add tags to Build' {
            Remove-VSTeamBuildTag -ProjectName project -id 2 -Tags $inputTags

            foreach ($inputTag in $inputTags) {
               Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
                  $Method -eq 'Delete' -and
                  $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/2/tags/?api-version=$($VSTeamVersionTable.Build)" + "&tag=$inputTag"
               }
            }
         }
      }

      Context 'Remove-VSTeamBuild on TFS local Auth handles exception' {

         # Arrange
         Mock _handleException -Verifiable
         Mock Invoke-RestMethod { throw 'Testing error handling.' }

         [string[]] $inputTags = "Test1", "Test2", "Test3"

         # Act
         Remove-VSTeamBuild -ProjectName project -id 2 -Force

         It 'should add tags to Build' {

            # Assert
            Assert-VerifiableMock
         }
      }

      Context 'Update Build number' {
         Mock Invoke-RestMethod

         Update-VSTeamBuild -projectName project -id 1 -BuildNumber 'TestNumber' -KeepForever $true -Force

         It 'should post changes' {
            Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter { $Method -eq 'Patch' -and $Body -eq '{"keepForever": true, "buildNumber": "TestNumber"}' -and $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/builds/1?api-version=$($VSTeamVersionTable.Build)" }
         }
      }
   }
}