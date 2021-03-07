Set-StrictMode -Version Latest

Describe 'VSTeamYamlPipeline' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      $testYamlPath = "$sampleFiles\azure-pipelines.test.yml"
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock Invoke-RestMethod { Open-SampleFile 'pipelineDefYamlResult.json' }
   }

   Context 'Test-VSTeamYamlPipeline' {

      It 'With Pipeline with PipelineID and without extra YAML' {
         Test-VSTeamYamlPipeline -projectName project -PipelineId 24

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/project/_apis/pipelines/24/runs*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*" -and
            $Body -like '*"PreviewRun":*true*' -and
            $Body -notlike '*YamlOverride*'
         }
      }

      It 'With Pipeline with PipelineID and YAML file path' {
         Test-VSTeamYamlPipeline -projectName project -PipelineId 24 -FilePath $testYamlPath

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/project/_apis/pipelines/24/runs*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*" -and
            $Body -like '*"PreviewRun":*true*' -and
            $Body -like '*YamlOverride*'
         }
      }

      It 'With Pipeline with PipelineID and YAML code' {
         $yamlOverride = [string](Get-Content -raw $testYamlPath)

         Test-VSTeamYamlPipeline -projectName project -PipelineId 24 -YamlOverride $yamlOverride

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/project/_apis/pipelines/24/runs*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*" -and
            $Body -like '*"PreviewRun":*true*' -and
            $Body -like '*YamlOverride*'
         }
      }

      It 'Should create Yaml result' {
         $yamlResult = Test-VSTeamYamlPipeline -projectName project -PipelineId 24 -FilePath $testYamlPath

         $yamlResult | Should -Not -Be $null
      }
   }
}