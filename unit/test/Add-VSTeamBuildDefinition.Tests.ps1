Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Classes/ProjectCompleter.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamBuildDefinition' {
   Context 'Add-VSTeamBuildDefinition' {
      ## Arrange
      $resultsVSTS = Get-Content "$PSScriptRoot\sampleFiles\buildDefvsts.json" -Raw | ConvertFrom-Json

      Mock Invoke-RestMethod { return $resultsVSTS }
      Mock _getProjects { return @() }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' }

      Context 'Services' {
         ## Arrange
         Mock _getInstance { return 'https://dev.azure.com/test' }

         it 'Should add build' {
            ## Act
            Add-VSTeamBuildDefinition -projectName project -inFile 'sampleFiles/builddef.json'

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Method -eq 'Post' -and
               $InFile -eq 'sampleFiles/builddef.json' -and
               $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions?api-version=$(_getApiVersion Build)"
            }
         }
      }

      Context 'Server' {
         ## Arrange
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' }

         it 'Should add build' {
            ## Act
            Add-VSTeamBuildDefinition -projectName project -inFile 'sampleFiles/builddef.json'

            ## Assert
            Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
               $Method -eq 'Post' -and
               $InFile -eq 'sampleFiles/builddef.json' -and
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions?api-version=$(_getApiVersion Build)"
            }
         }
      }
   }
}