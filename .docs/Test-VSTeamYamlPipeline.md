<!-- #include "./common/header.md" -->

# Test-VSTeamMembership

## SYNOPSIS

<!-- #include "./synopsis/Test-VSTeamYamlPipeline.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Test-VSTeamYamlPipeline.md" -->

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Test-VSTeamYamlPipeline -Project DemoProject -PipelineId 24 -FilePath './azure-pipelines.yml'

Build Definition Build Number  Status     Result
---------------- ------------  ------     ------
Demo-CI           Demo-CI-45   notStarted
```

This example checks the YAML pipeline with ID 24 and the file './azure-pipelines.yml' for consistency on Azure DevOps to see if the changes still work.

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

## RELATED LINKS
