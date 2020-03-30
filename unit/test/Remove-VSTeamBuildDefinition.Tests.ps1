Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

$resultsVSTS = Get-Content "$PSScriptRoot\sampleFiles\buildDefvsts.json" -Raw | ConvertFrom-Json

Describe 'Remove-VSTeamBuildDefinition' {
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable
      
   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"

   Context 'Succeeds' {
      Mock Invoke-RestMethod { return $resultsVSTS }

      It 'should delete build definition' {
         Remove-VSTeamBuildDefinition -projectName project -id 2 -Force

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Delete' -and
            $Uri -eq "https://dev.azure.com/test/project/_apis/build/definitions/2?api-version=$(_getApiVersion Build)"
         }
      }
   }

   Context 'Succeeds on TFS local Auth' {
      Mock Invoke-RestMethod { return $resultsVSTS }
      Mock _useWindowsAuthenticationOnPremise { return $true }
      Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

      Remove-VSTeamBuildDefinition -projectName project -id 2 -Force

      It 'should delete build definition' {
         Assert-MockCalled Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
            $Method -eq 'Delete' -and
            $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/build/definitions/2?api-version=$(_getApiVersion Build)"
         }
      }
   }
}