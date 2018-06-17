Set-StrictMode -Version Latest

Get-Module VSTeam | Remove-Module -Force
# Required for the dynamic parameter
Import-Module $PSScriptRoot\..\..\src\team.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\builds.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\releases.psm1 -Force
Import-Module $PSScriptRoot\..\..\src\releaseDefinitions.psm1 -Force

# Loading System.Web avoids issues finding System.Web.HttpUtility
Add-Type -AssemblyName 'System.Web'

InModuleScope releases {
   $VSTeamVersionTable.Account = 'https://test.visualstudio.com'
   $VSTeamVersionTable.Release = '1.0-unittest'

   $results = [PSCustomObject]@{
      value = [PSCustomObject]@{
         environments = [PSCustomObject]@{}
         _links       = [PSCustomObject]@{ 
            self = [PSCustomObject]@{}
            web  = [PSCustomObject]@{}
         }
      }
   }

   $singleResult = [PSCustomObject]@{
      environments = [PSCustomObject]@{}
      _links       = [PSCustomObject]@{ 
         self = [PSCustomObject]@{}
         web  = [PSCustomObject]@{}
      }
   }

   Describe 'Releases' {
      . "$PSScriptRoot\mockProjectNameDynamicParamNoPSet.ps1"

      Context 'Show-VSTeamRelease by ID' {
         Mock _openOnWindows { }
         Mock _isOnWindows { return $true }

         it 'should show release' {
            Show-VSTeamRelease -projectName project -Id 15

            Assert-MockCalled _openOnWindows -Exactly -Scope It -Times 1 -ParameterFilter {
               $command -eq 'https://test.visualstudio.com/project/_release?releaseId=15'
            }
         }
      }

      Context 'Show-VSTeamRelease with invalid ID' {
         it 'should show release' {
            { Show-VSTeamRelease -projectName project -Id 0 } | Should throw 
         }
      }

      Context 'Remove-VSTeamRelease by ID' {
         Mock Invoke-RestMethod

         It 'should return releases' {
            Remove-VSTeamRelease -ProjectName project -Id 15 -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { 
               $Method -eq 'Delete' -and
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/15?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      Context 'Remove-VSTeamRelease by ID throws' {
         Mock Invoke-RestMethod { throw 'error'}

         It 'should return releases' {
            { Remove-VSTeamRelease -ProjectName project -Id 150000 -Force } | Should Throw
         }
      }

      Context 'Set-VSTeamReleaseStatus by ID' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod

         It 'should set release status' {
            Set-VSTeamReleaseStatus -ProjectName project -Id 15 -Status Abandoned -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Patch' -and
               $Body -eq '{ "id": 15, "status": "Abandoned" }' -and
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/15?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      Context 'Set-VSTeamReleaseStatus by ID throws' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod { throw 'error' }

         It 'should set release status' {
            { Set-VSTeamReleaseStatus -ProjectName project -Id 15 -Status Abandoned -Force } | Should Throw
         }
      }

      Context 'Get-VSTeamRelease by ID' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod {
            return $singleResult 
         }

         It 'should return releases' {
            Get-VSTeamRelease -ProjectName project -Id 15

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { 
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/15?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }
    
      Context 'Get-VSTeamRelease with no parameters' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod {
            return $results 
         }

         It 'should return releases' {
            Get-VSTeamRelease -projectName project

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { 
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      Context 'Get-VSTeamRelease with expand environments' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod {
            return $results 
         }

         It 'should return releases' {
            Get-VSTeamRelease -projectName project -expand environments

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { 
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/?api-version=$($VSTeamVersionTable.Release)&`$expand=environments"
            }
         }
      }

      Context 'Get-VSTeamRelease with no parameters & no project' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Invoke-RestMethod {
            return $results 
         }

         It 'should return releases' {
            Get-VSTeamRelease

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter { 
               $Uri -eq "https://test.vsrm.visualstudio.com/_apis/release/releases/?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }   
      
      Context 'Set-VSTeamEnvironmentStatus by ID' {
         Mock _useWindowsAuthenticationOnPremise { return $false }
         Mock Invoke-RestMethod

         $expectedBody = ConvertTo-Json ([PSCustomObject]@{status = 'inProgress'; comment = ''; scheduledDeploymentTime = $null})

         It 'should set environments' {
            Set-VSTeamEnvironmentStatus -ProjectName project -ReleaseId 1 -Id 15 -Status inProgress -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Patch' -and
               $Body -eq $expectedBody -and
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/1/environments/15?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      Context 'Set-VSTeamEnvironmentStatus by ID throws' {
         Mock _useWindowsAuthenticationOnPremise { return $false }
         Mock Invoke-RestMethod { throw 'error' }

         It 'should set environments' {
            { Set-VSTeamEnvironmentStatus -ProjectName project -ReleaseId 1 -Id 15 -Status inProgress -Force } | Should Throw
         }
      }

      Context 'Add-VSTeamRelease by ID' {
         Mock Invoke-RestMethod {
            return $singleResult
         }

         It 'should add a release' {
            Add-VSTeamRelease -ProjectName project -DefinitionId 1 -ArtifactAlias drop -BuildId 2

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $Body -like '*"definitionId": 1*' -and
               $Body -like '*"description": ""*' -and
               $Body -like '*"alias": "drop"*' -and
               $Body -like '*"id": "2"*' -and
               $Body -like '*"sourceBranch": ""*' -and
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      Context 'Add-VSTeamRelease by name' {
         BeforeAll {
            $Global:PSDefaultParameterValues["*:projectName"] = 'project'
         }

         AfterAll {
            $Global:PSDefaultParameterValues.Remove("*:projectName")
         }

         Mock Get-VSTeamReleaseDefinition {
            $def1 = New-Object -TypeName PSObject -Prop @{name = 'Test1'; id = 1; artifacts = @(@{alias = 'drop'})}
            $def2 = New-Object -TypeName PSObject -Prop @{name = 'Tests'; id = 2; artifacts = @(@{alias = 'drop'})}
            return @(
               $def1,
               $def2
            )
         }

         Mock Get-VSTeamBuild {
            $bld1 = New-Object -TypeName PSObject -Prop @{name = "Bld1"; id = 1}
            $bld2 = New-Object -TypeName PSObject -Prop @{name = "Bld2"; id = 2}

            return @(
               $bld1,
               $bld2
            )
         }

         Mock Invoke-RestMethod {
            return $singleResult
         }

         Mock _buildDynamicParam {
            param(
               [string] $ParameterName = 'QueueName',
               [array] $arrSet,
               [bool] $Mandatory = $false,
               [string] $ParameterSetName
            )

            # Create the collection of attributes
            $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]

            # Create and set the parameters' attributes
            $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
            $ParameterAttribute.Mandatory = $Mandatory
            $ParameterAttribute.ValueFromPipelineByPropertyName = $true

            if ($ParameterSetName) {
               $ParameterAttribute.ParameterSetName = $ParameterSetName
            }

            # Add the attributes to the attributes collection
            $AttributeCollection.Add($ParameterAttribute)

            if ($arrSet) {
               # Generate and set the ValidateSet
               $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)

               # Add the ValidateSet to the attributes collection
               $AttributeCollection.Add($ValidateSetAttribute)
            }

            # Create and return the dynamic parameter
            return New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
         }

         It 'should add a release' {
            Add-VSTeamRelease -ProjectName project -BuildNumber 'Bld1' -DefinitionName 'Test1'

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $Body -like '*"definitionId": 1*' -and
               $Body -like '*"description": ""*' -and
               $Body -like '*"alias": "drop"*' -and
               $Body -like '*"id": "1"*' -and
               $Body -like '*"sourceBranch": ""*' -and
               $Uri -eq "https://test.vsrm.visualstudio.com/project/_apis/release/releases/?api-version=$($VSTeamVersionTable.Release)"
            }
         }
      }

      Context 'Add-VSTeamRelease throws' {
         Mock Invoke-RestMethod { throw 'error' }

         It 'should add a release' {
            { Add-VSTeamRelease -ProjectName project -DefinitionId 1 -ArtifactAlias drop -BuildId 2 } | Should Throw
         }
      }
   }
}