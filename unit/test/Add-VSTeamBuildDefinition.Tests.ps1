Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

$resultsVSTS = Get-Content "$PSScriptRoot\sampleFiles\buildDefvsts.json" -Raw | ConvertFrom-Json

Describe 'Add-VSTeamBuildDefinition' {
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
      
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   Context 'Succeeds' {
      Mock Invoke-RestMethod { return $resultsVSTS }

      it 'Should add build' {
         Add-VSTeamBuildDefinition -projectName project -inFile 'sampleFiles/builddef.json'

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $InFile -eq 'sampleFiles/builddef.json' -and
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions?api-version=$([VSTeamVersions]::Build)"
         }
      }
   }

   Context 'Succeeds on TFS local Auth' {
      Mock Invoke-RestMethod { return $resultsVSTS }
      Mock _useWindowsAuthenticationOnPremise { return $true }
      Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

      it 'Should add build' {
         Add-VSTeamBuildDefinition -projectName project -inFile 'sampleFiles/builddef.json'

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $InFile -eq 'sampleFiles/builddef.json' -and
            $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions?api-version=$([VSTeamVersions]::Build)"
         }
      }
   }
}