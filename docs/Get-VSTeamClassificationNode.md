


# Get-VSTeamClassificationNode

## SYNOPSIS

Gets the classification node for a given node path.

## SYNTAX

## DESCRIPTION

Gets the classification node for a given node path.

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

### -StructureGroup

Structure group of the classification node, area or iteration.

```yaml
Type: string
```

### -Depth

Depth of children to fetch.

```yaml
Type: int32
```

### -Path

Path of the classification node.

```yaml
Type: string
```

### -Ids

Integer classification nodes ids.

```yaml
Type: int32[]
```

## INPUTS

## OUTPUTS

### System.Object

## NOTES

This function is the base function for Get-VSTeamArea and Get-VSTeamIteration.

## RELATED LINKS

[Get-VSTeamArea](Get-VSTeamArea.md)

[Get-VSTeamIteration](Get-VSTeamIteration.md)

