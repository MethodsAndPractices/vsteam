<!-- #include "./common/header.md" -->

# Get-VSTeamClassificationNode

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamClassificationNode.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamClassificationNode.md" -->

## PARAMETERS

<!-- #include "./params/projectName.md" -->

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
