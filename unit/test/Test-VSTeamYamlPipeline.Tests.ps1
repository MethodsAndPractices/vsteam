Set-StrictMode -Version Latest

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"

$resultsAzD = Get-Content "$PSScriptRoot\sampleFiles\pipelineDefYamlResult.json" -Raw | ConvertFrom-Json

Describe 'Test-VSTeamYamlPipeline' {
   Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

   # Mock the call to Get-Projects by the dynamic parameter for ProjectName
   Mock Invoke-RestMethod { return @() } -ParameterFilter {
      $Uri -like "*_apis/projects*"
   }

   . "$PSScriptRoot\mocks\mockProjectNameDynamicParamNoPSet.ps1"
   $testYamlPath = "$PSScriptRoot\sampleFiles\azure-pipelines.test.yml"

   Context 'Yaml Pipeline Checks AzD Services' {
      Mock Invoke-RestMethod {
         # If this test fails uncomment the line below to see how the mock was called.
         # Write-Host $args
         # Write-Host $([VSTeamVersions]::Build)
         # Write-Host $([VSTeamVersions]::Account)

         return $resultsAzD
      }

      It 'With Pipeline with PipelineID and without extra YAML' {
         Test-VSTeamYamlPipeline -projectName project -PipelineId 24

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {

            $Uri -like "*https://dev.azure.com/test/project/_apis/pipelines/24/runs*" -and
            $Uri -like "*api-version=$(_getApiVersion Build)*" -and
            $Body -like '*"PreviewRun":*true*' -and
            $Body -notlike '*YamlOverride*'
         }
      }

      It 'With Pipeline with PipelineID and YAML file path' {

         Test-VSTeamYamlPipeline -projectName project -PipelineId 24 -FilePath $testYamlPath

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {

            $Uri -like "*https://dev.azure.com/test/project/_apis/pipelines/24/runs*" -and
            $Uri -like "*api-version=$(_getApiVersion Build)*" -and
            $Body -like '*"PreviewRun":*true*' -and
            $Body -like '*YamlOverride*'
         }
      }

      It 'With Pipeline with PipelineID and YAML code' {

         $yamlOverride = [string](Get-Content -raw $testYamlPath)
         Test-VSTeamYamlPipeline -projectName project -PipelineId 24 -YamlOverride $yamlOverride

         Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {

            $Uri -like "*https://dev.azure.com/test/project/_apis/pipelines/24/runs*" -and
            $Uri -like "*api-version=$(_getApiVersion Build)*" -and
            $Body -like '*"PreviewRun":*true*' -and
            $Body -like '*YamlOverride*'
         }
      }

      $yamlResult = Test-VSTeamYamlPipeline -projectName project -PipelineId 24 -FilePath $testYamlPath

      It 'Should create Yaml result' {
         $yamlResult | Should Not be $null
      }
   }
}