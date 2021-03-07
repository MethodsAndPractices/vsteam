<!-- #include "./common/header.md" -->

# Add-VSTeamBuild

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamBuild.md" -->

## SYNTAX

## DESCRIPTION

Add-VSTeamBuild will queue a new build.

You can override the queue in the build definition by using the QueueName parameter. You can override the default source branch by using the SourceBranch parameter. You can also set specific build parameters by using the BuildParameters parameter.

To have the BuildDefinition and QueueNames tab complete you must set a default project by calling Set-VSTeamDefaultProject before you call Add-VSTeamBuild.

## EXAMPLES

### Example 1

```powershell
Set-VSTeamDefaultProject Demo
Add-VSTeamBuild -BuildDefinition Demo-CI

Build Definition Build Number  Status     Result
---------------- ------------  ------     ------
Demo-CI           Demo-CI-45   notStarted
```

This example sets the default project so you can tab complete the BuildDefinition parameter.

### Example 2

```powershell
Set-VSTeamDefaultProject Demo
Add-VSTeamBuild -BuildDefinition Demo-CI -SourceBranch refs/heads/develop

Build Definition Build Number  Status     Result
---------------- ------------  ------     ------
Demo-CI           Demo-CI-45   notStarted
```

This example queues the build for the 'develop' branch, overriding the default branch in the build definition.

### Example 3

```powershell
Set-VSTeamDefaultProject Demo
Add-VSTeamBuild -BuildDefinition Demo-CI -BuildParameters @{msg="hello world!"; 'system.debug'='true'}

Build Definition Build Number  Status     Result
---------------- ------------  ------     ------
Demo-CI           Demo-CI-45   notStarted
```

This example queues the build and sets the system.debug variable to true and msg to 'hello world!'.

## PARAMETERS

### BuildDefinitionName

The name of the build definition to use to queue to build.

```yaml
Type: String
Parameter Sets: ByName
Aliases: BuildDefinition
Accept pipeline input: true (ByPropertyName)
```

### QueueName

The name of the queue to use for this build.

```yaml
Type: String
Accept pipeline input: true (ByPropertyName)
```

### BuildDefinitionId

The Id of the build definition to use to queue to build.

```yaml
Type: Int32
Parameter Sets: ByID
Aliases: Id
Accept pipeline input: true (ByPropertyName)
```

### SourceBranch

Which source branch to use for this build. Overrides default branch in build definition.

```yaml
Type: String
```

### BuildParameters

A hashtable with build parameters.

```yaml
Type: System.Collection.Hashtable
```

<!-- #include "./params/projectName.md" -->

## INPUTS

### System.String

ProjectName

BuildDefinitionName

QueueName

SourceBranch

### System.Int32

BuildDefinitionId

### System.Collections.Hashtable

Build Parameters

## OUTPUTS

### vsteam_lib.Build

## NOTES

BuildDefinition and QueueName are dynamic parameters and use the default project value to query their validate set.

If you do not set the default project by called Set-VSTeamDefaultProject you must pass in -ProjectName or you will have to type in the names.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
