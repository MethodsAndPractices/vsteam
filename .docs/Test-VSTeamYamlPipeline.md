<!-- #include "./common/header.md" -->

# Test-VSTeamYamlPipeline

## SYNOPSIS

<!-- #include "./synopsis/Test-VSTeamYamlPipeline.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Test-VSTeamYamlPipeline.md" -->

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Test-VSTeamYamlPipeline -Project DemoProject -PipelineId 24 -FilePath './azure-pipelines.yml'

Name Id url                                                                                           state
---- -- ---                                                                                           -----
     -1 https://dev.azure.com/devsdb/3428bdd7-9fed-4c30-a6c9-fcb52f084ab9/_apis/pipelines/24/runs/-1 unknown
```

This example checks the YAML pipeline with ID 24 and the file './azure-pipelines.yml' for consistency on Azure DevOps to see if the changes still work.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> $yamlOverride = [string](Get-Content -raw $FilePath)
PS C:\> Test-VSTeamYamlPipeline -Project DemoProject -PipelineId 24 -YamlOverride $yamlOverride
```

This example checks the YAML pipeline with ID 24 and the content of a yaml file in the variable $yamlOverride for consistency on Azure DevOps to see if the changes still work.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> $yamlOverride = [string](Get-Content -raw $FilePath)
PS C:\> Test-VSTeamYamlPipeline -Project DemoProject -PipelineId 24
```

This example checks the YAML pipeline with ID 24 for consistency on Azure DevOps to see if the existing YAML of the pipeline works.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -PipelineId

Id of the YAML pipeline to be checked

```yaml
Type: Int32
Position: 1
```

### -FilePath

Path to the file that should be checked

```yaml
Type: String
```

## INPUTS

### System.String

FilePath

### System.Int32

PipelineId

## OUTPUTS

### Team.YamlPipelineResult

## NOTES

If you do not set the default project by called Set-VSTeamDefaultProject before calling Add-VSTeamBuild you will have to type in the names.

Currently the API that is used by this cmdlet is only supporting YAML pipelines without template references. This will be supported soon. see the issue in GitHub: [https://github.com/microsoft/azure-pipelines-yaml/issues/34#issuecomment-591092498](https://github.com/microsoft/azure-pipelines-yaml/issues/34#issuecomment-591092498)

## RELATED LINKS

[Get-VSTeamBuildDefinition](Get-VSTeamBuildDefinition.md)
