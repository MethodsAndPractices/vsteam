Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamFeed.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Public/Get-VSTeamBuild.ps1"
. "$here/../../Source/Public/Get-VSTeamReleaseDefinition.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamRelease' {
   ## Arrange
   [VSTeamVersions]::Release = '1.0-unittest'
   
   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   Mock _getInstance { return 'https://dev.azure.com/test' }

   $singleResult = [PSCustomObject]@{
      environments = [PSCustomObject]@{ }
      variables    = [PSCustomObject]@{
         BrowserToUse = [PSCustomObject]@{
            value = "phantomjs"
         }
      }
      _links       = [PSCustomObject]@{
         self = [PSCustomObject]@{ }
         web  = [PSCustomObject]@{ }
      }
   }
   
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter { $Uri -like "*_apis/projects*" }

   Context 'Add-VSTeamRelease' {
      ## Arrange
      BeforeAll {
         $Global:PSDefaultParameterValues["*:projectName"] = 'project'
      }

      AfterAll {
         $Global:PSDefaultParameterValues.Remove("*:projectName")
      }

      Mock Get-VSTeamReleaseDefinition {
         $def1 = New-Object -TypeName PSObject -Prop @{name = 'Test1'; id = 1; artifacts = @(@{alias = 'drop' }) }
         $def2 = New-Object -TypeName PSObject -Prop @{name = 'Tests'; id = 2; artifacts = @(@{alias = 'drop' }) }
         return @(
            $def1,
            $def2
         )
      }

      Mock Get-VSTeamBuild {
         $bld1 = New-Object -TypeName PSObject -Prop @{name = "Bld1"; id = 1 }
         $bld2 = New-Object -TypeName PSObject -Prop @{name = "Bld2"; id = 2 }

         return @(
            $bld1,
            $bld2
         )
      }

      Mock Invoke-RestMethod { return $singleResult }
      Mock Invoke-RestMethod { throw 'error' } -ParameterFilter { $Body -like "*101*" }

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

      It 'by name should add a release' {
         ## Act
         Add-VSTeamRelease -ProjectName project -BuildNumber 'Bld1' -DefinitionName 'Test1'

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*"definitionId": 1*' -and
            $Body -like '*"description": ""*' -and
            $Body -like '*"alias": "drop"*' -and
            $Body -like '*"id": "1"*' -and
            $Body -like '*"sourceBranch": ""*' -and
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases?api-version=$([VSTeamVersions]::Release)"
         }
      }

      It 'by Id should add a release' {
         ## Act
         Add-VSTeamRelease -ProjectName project -DefinitionId 1 -ArtifactAlias drop -BuildId 2

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*"definitionId": 1*' -and
            $Body -like '*"description": ""*' -and
            $Body -like '*"alias": "drop"*' -and
            $Body -like '*"id": "2"*' -and
            $Body -like '*"sourceBranch": ""*' -and
            $Uri -eq "https://vsrm.dev.azure.com/test/project/_apis/release/releases?api-version=$([VSTeamVersions]::Release)"
         }
      }

      It 'should throw' {
         ## Act / Assert
         { Add-VSTeamRelease -ProjectName project -DefinitionId 101 -ArtifactAlias drop -BuildId 101 } | Should Throw
      }
   }
}