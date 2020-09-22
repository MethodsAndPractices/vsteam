<!-- #include "./common/header.md" -->

# Get-VSTeamClassificationNode

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamClassificationNode.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamClassificationNode.md" -->

## PARAMETERS

### StructureGroup

Structure group of the classification node, area or iteration.

```yaml
Type: string
```

### Depth

Depth of children to fetch.

```yaml
Type: int32
```

### Path

Path of the classification node.

```yaml
Type: string
```

### Id

Integer classification nodes ids.

```yaml
Type: int32[]
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

This function is the base function for Get-VSTeamArea and Get-VSTeamIteration.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Get-VSTeamArea](Get-VSTeamArea.md)

[Get-VSTeamIteration](Get-VSTeamIteration.md)
