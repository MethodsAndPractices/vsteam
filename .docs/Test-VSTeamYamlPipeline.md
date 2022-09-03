<!-- #include "./common/header.md" -->

# Test-VSTeamYamlPipeline

## SYNOPSIS

<!-- #include "./synopsis/Test-VSTeamYamlPipeline.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Test-VSTeamYamlPipeline.md" -->

 Now, you can try out a YAML pipeline without committing it to a repo or running it. Given an existing pipeline and an optional new YAML payload, this function will give you back the fully compiled YAML pipeline including templates.

## EXAMPLES

### Example 1

```powershell
Test-VSTeamYamlPipeline -Project DemoProject -PipelineId 24 -FilePath './azure-pipelines.yml'
```

This example checks the YAML pipeline with ID 24 and the file './azure-pipelines.yml' for consistency on Azure DevOps to see if the changes still work.

### Example 2

```powershell
$yamlOverride = [string](Get-Content -raw $FilePath)
Test-VSTeamYamlPipeline -Project DemoProject -PipelineId 24 -YamlOverride $yamlOverride
```

This example checks the YAML pipeline with ID 24 and the content of a yaml file in the variable $yamlOverride for consistency on Azure DevOps to see if the changes still work.

### Example 3

```powershell
Test-VSTeamYamlPipeline -Project DemoProject -PipelineId 24 -Branch 'main'
```

This example checks the YAML in the remote repository connected to the pipeline with ID 24 for consistency on Azure DevOps. It will take the file for the branch 'main'.

### Example 4

```powershell
Test-VSTeamYamlPipeline -Project DemoProject -PipelineId 24 - Branch 'refs/heads/feature/test'
```

This example checks the YAML in the remote repository connected to the pipeline with ID 24 for consistency on Azure DevOps. It will take the file for the branch ref 'refs/heads/feature/test'.

### Example 5

```powershell
Test-VSTeamYamlPipeline -Project DemoProject -PipelineId 24
```

This example checks the YAML file pipeline with ID 24 for consistency on Azure DevOps to see if the existing YAML of the pipeline works.

## PARAMETERS

### PipelineId

Id of the YAML pipeline to be checked

```yaml
Type: Int32
Position: 1
```

### FilePath

Path to the file that should be checked

```yaml
Type: String
```

### Branch

branch name of the remote repository where the YAML file should be checked

```yaml
Type: String
```

<!-- #include "./params/projectName.md" -->

## INPUTS

### System.String

FilePath

### System.Int32

PipelineId

## OUTPUTS

### vsteam_lib.YamlPipelineResult

## NOTES

Currently the API that is used by this cmdlet is only supporting YAML pipelines without template references. This will be supported soon. see the issue in GitHub: [https://github.com/microsoft/azure-pipelines-yaml/issues/34#issuecomment-591092498](https://github.com/microsoft/azure-pipelines-yaml/issues/34#issuecomment-591092498)

This cmdlet is not starting a pipeline run, but rather trying to resolve the full YAML code. It will not check if the task themselves work. See here for more info [https://www.razorspoint.com/2020/03/13/how-to-preview-and-test-a-changing-yaml-pipeline-on-azure-devops/](https://www.razorspoint.com/2020/03/13/how-to-preview-and-test-a-changing-yaml-pipeline-on-azure-devops/)

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Get-VSTeamBuildDefinition](Get-VSTeamBuildDefinition.md)
