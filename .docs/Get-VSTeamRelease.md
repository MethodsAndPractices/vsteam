<!-- #include "./common/header.md" -->

# Get-VSTeamRelease

## SYNOPSIS

Gets the releases for a team project.

## SYNTAX

## DESCRIPTION

The Get-VSTeamRelease function gets the releases for a team project.

The project name is a Dynamic Parameter which may not be displayed in the syntax above but is mandatory.

With just a project name, this function gets all of the releases for that team project.

You can also specify a particular release defintion by ID.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamRelease -ProjectName demo | Format-List *
```

This command gets a list of all releases in the demo project.

The pipeline operator (|) passes the data to the Format-List cmdlet, which displays all available properties (*) of the release defintion objects.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -Expand

Specifies which property should be expanded in the list of Release (environments, artifacts, none).

```yaml
Type: String
Parameter Sets: List
```

### -StatusFilter

Draft, Active or Abandoned.

```yaml
Type: String
Parameter Sets: List
```

### -DefinitionId

Id of the release definition

```yaml
Type: Int32
Parameter Sets: List
Default value: 0
```

### -Top

Specifies the maximum number to return.

```yaml
Type: Int32
Parameter Sets: List
Default value: 0
```

### -CreatedBy

```yaml
Type: String
Parameter Sets: List
```

### -MinCreatedTime

```yaml
Type: DateTime
Parameter Sets: List
```

### -MaxCreatedTime

```yaml
Type: DateTime
Parameter Sets: List
```

### -QueryOrder

```yaml
Type: String
Parameter Sets: List
```

### -ContinuationToken

```yaml
Type: String
Parameter Sets: List
```

### -Id

Specifies one or more releases by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a release defintion, type Get-VSTeamRelease.

```yaml
Type: Int32[]
Parameter Sets: ByID
Aliases: ReleaseID
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

### Team.Release

## NOTES

This function has a Dynamic Parameter for ProjectName that specifies the project for which this function gets releases.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have to pass the ProjectName with each call.

You can pipe release defintion IDs to this function.

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Add-VSTeamRelease](Add-VSTeamRelease.md)

[Remove-VSTeamRelease](Remove-VSTeamRelease.md)