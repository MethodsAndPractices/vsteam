


# Add-VSTeamRelease

## SYNOPSIS

Queues a new release

## SYNTAX

## DESCRIPTION

Add-VSTeamRelease will queue a new release.

The environments will deploy according to how the release definition is configured in the Triggers tab.

You must call Set-VSTeamAccount before calling this function.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamBuild | ft id,name

id name
-- ----
44 Demo-CI-44

PS C:\> Get-VSTeamReleaseDefinition -Expand artifacts | ft id,name,@{l='Alias';e={$_.artifacts[0].alias}}

id name    Alias
-- ----    -----
 1 Demo-CD Demo-CI

PS C:\> Add-VSTeamRelease -DefinitionId 1 -Description Test -ArtifactAlias Demo-CI -BuildId 44
```

This example shows how to find the Build ID, Artifact Alias, and Release definition ID required to start a release. If you call Set-VSTeamDefaultProject you can use Example 2 which is much easier.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Add-VSTeamRelease -DefinitionName Demo-CD -Description Test -BuildNumber Demo-CI-44
```

This command starts a new release using the Demo-CD release definition and the build with build number Demo-CI-44.

You must set a default project to tab complete DefinitionName and BuildNumber.

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: 0
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -DefinitionId

The id of the release definition to use.

```yaml
Type: Int32
Parameter Sets: ById
Required: True
```

### -Description

The description to use on the release.

```yaml
Type: String
Required: True
```

### -ArtifactAlias

The alias of the artifact to use with this release.

```yaml
Type: String
Parameter Sets: ById
Required: True
```

### -Name

The name of this release.

```yaml
Type: String
```

### -BuildId

The id of the build to use with this release.

```yaml
Type: String
Parameter Sets: ById
Required: True
```

### -DefinitionName

The name of the release definition to use.

```yaml
Type: String
Parameter Sets: ByName
Accept pipeline input: true (ByPropertyName)
```

### -SourceBranch

The branch of the artifact

```yaml
Type: String
```

### -BuildNumber

The number of the build to use.

```yaml
Type: String
Parameter Sets: ByName
Accept pipeline input: true (ByPropertyName)
```

### -Force

Forces the function without confirmation

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
```

## INPUTS

## OUTPUTS

## NOTES

This function has a Dynamic Parameter for ProjectName that specifies the project for which this function gets releases.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have to pass the ProjectName with each call.

## RELATED LINKS

