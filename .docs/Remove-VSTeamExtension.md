<!-- #include "./common/header.md" -->

# Remove-VSTeamExtension

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamExtension.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamExtension.md" -->

## EXAMPLES

### Example 1
```powershell
Remove-VSTeamExtension -PublisherId "Contoso" -ExtensionId "MyExtension"
```

Removes the extension "MyExtension" from the publisher "Contoso".

### Example 2
```powershell
Remove-VSTeamExtension -PublisherId "Contoso" -ExtensionId "MyExtension" -Force
```

Removes the extension "MyExtension" from the publisher "Contoso" and forces the removal without any confirmation prompts.

## PARAMETERS

### PublisherId

The id of the publisher.

```yaml
Type: String
Required: True
```

### ExtensionId

The id of the extension.

```yaml
Type: String
Required: True
```

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Add-VSTeamExtension](Add-VSTeamExtension.md)

[Get-VSTeamExtension](Get-VSTeamExtension.md)

[Remove-VSTeamExtension](Remove-VSTeamExtension.md)

[Update-VSTeamExtension](Update-VSTeamExtension.md)
