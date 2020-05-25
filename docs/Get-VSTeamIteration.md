


# Get-VSTeamIteration

## SYNOPSIS

Gets the iteration node for a given iteration path.

## SYNTAX

## DESCRIPTION

Gets the iteration node for a given iteration path.

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

This is a wrapper function for Get-VSTeamClassificationNode

## RELATED LINKS

[Get-VSTeamClassificationNode](Get-VSTeamClassificationNode.md)

[Get-VSTeamIteration](Get-VSTeamIteration.md)

