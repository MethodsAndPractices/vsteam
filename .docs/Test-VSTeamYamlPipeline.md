<!-- #include "./common/header.md" -->

# Test-VSTeamYamlPipeline

## SYNOPSIS

<!-- #include "./synopsis/Test-VSTeamYamlPipeline.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Test-VSTeamYamlPipeline.md" -->

## EXAMPLES

### Example 1

```powershell
Test-VSTeamYamlPipeline -Project DemoProject -PipelineId 24 -FilePath './azure-pipelines.yml'

Name Id url                                                                                           state
---- -- ---                                                                                           -----
     -1 https://dev.azure.com/devsdb/3428bdd7-9fed-4c30-a6c9-fcb52f084ab9/_apis/pipelines/24/runs/-1 unknown
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
$yamlOverride = [string](Get-Content -raw $FilePath)
Test-VSTeamYamlPipeline -Project DemoProject -PipelineId 24
```

This example checks the YAML pipeline with ID 24 for consistency on Azure DevOps to see if the existing YAML of the pipeline works.

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

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Get-VSTeamBuildDefinition](Get-VSTeamBuildDefinition.md)
