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
         Test-VSTeamYamlPipeline -projectName project -PipelineId 24 -WarningAction SilentlyContinue

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/project/_apis/pipelines/24/runs*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*" -and
            $Body -like '*"PreviewRun":*true*' -and
            $Body -notlike '*YamlOverride*'
         }
      }

      It 'With Pipeline with PipelineID and YAML file path' {
         Test-VSTeamYamlPipeline -projectName project -PipelineId 24 -FilePath $testYamlPath -WarningAction SilentlyContinue

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/project/_apis/pipelines/24/runs*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*" -and
            $Body -like '*"PreviewRun":*true*' -and
            $Body -like '*YamlOverride*'
         }
      }

      It 'With Pipeline with PipelineID, Branch name and YAML file path' {
         Test-VSTeamYamlPipeline -projectName project -PipelineId 24 -FilePath $testYamlPath -Branch 'refs/heads/feature/myfeature'

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/project/_apis/pipelines/24/runs*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*" -and
            $Body -like '*"PreviewRun":*true*' -and
            $Body -like '*"refName":"feature/myfeature"*' -and
            $Body -like '*YamlOverride*'
         }
      }

      It 'With Pipeline with PipelineID, short Branch name' {
         Test-VSTeamYamlPipeline -projectName project -PipelineId 24 -Branch 'feature/myfeature'

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/project/_apis/pipelines/24/runs*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*" -and
            $Body -like '*"PreviewRun":*true*' -and
            $Body -like '*"refName":"feature/myfeature"*'
         }
      }

      It 'With Pipeline with PipelineID, with long "refs/heads" Branch name' {
         Test-VSTeamYamlPipeline -projectName project -PipelineId 24 -Branch 'refs/heads/feature/myfeature'

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/project/_apis/pipelines/24/runs*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*" -and
            $Body -like '*"PreviewRun":*true*' -and
            $Body -like '*"refName":"feature/myfeature"*'
         }
      }

      It 'With Pipeline with PipelineID and YAML code' {
         $yamlOverride = [string](Get-Content -raw $testYamlPath)

         Test-VSTeamYamlPipeline -projectName project -PipelineId 24 -YamlOverride $yamlOverride -WarningAction SilentlyContinue

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/project/_apis/pipelines/24/runs*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*" -and
            $Body -like '*"PreviewRun":*true*' -and
            $Body -like '*YamlOverride*'
         }

      }

      It 'With Pipeline with PipelineID, Branch name and YAML file path' {
         $yamlOverride = [string](Get-Content -raw $testYamlPath)

         Test-VSTeamYamlPipeline -projectName project -PipelineId 24 -YamlOverride $yamlOverride -Branch 'refs/heads/feature/myfeature'

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Uri -like "*https://dev.azure.com/test/project/_apis/pipelines/24/runs*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*" -and
            $Body -like '*"PreviewRun":*true*' -and
            $Body -like '*"refName":"feature/myfeature"*' -and
            $Body -like '*YamlOverride*'
         }
      }

      It 'Should create Yaml result' {
         $yamlResult = Test-VSTeamYamlPipeline -projectName project -PipelineId 24 -FilePath $testYamlPath -WarningAction SilentlyContinue

         $yamlResult | Should -Not -Be $null
      }

      It 'Should throw warning if no Branch specified' {

         Mock Write-Warning -MockWith {
            return $Message
         }

         Test-VSTeamYamlPipeline -projectName project -PipelineId 24 -WarningAction SilentlyContinue

         Should -Invoke Write-Warning -Exactly -Scope It -Times 1 -ParameterFilter {
            $Message -like '*No branch specified, Azure DevOps api is using ''ref/heads/main''*'
         }

      }
   }
}