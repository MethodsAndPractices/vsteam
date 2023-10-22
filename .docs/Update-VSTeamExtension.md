<!-- #include "./common/header.md" -->

# Update-VSTeamExtension

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamExtension.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeamExtension.md" -->

## EXAMPLES

### Example 1
```powershell
Update-VSTeamExtension -PublisherId "Contoso" -ExtensionId "MyExtension" -ExtensionState "disabled"
```

Disables the extension "MyExtension" from the publisher "Contoso".

### Example 2
```powershell
Update-VSTeamExtension -PublisherId "Contoso" -ExtensionId "MyExtension" -ExtensionState "none"
```

Sets the extension state to "none" for the extension "MyExtension" from the publisher "Contoso".

### Example 3
```powershell
Update-VSTeamExtension -PublisherId "Contoso" -ExtensionId "MyExtension" -ExtensionState "disabled" -Force
```

Disables the extension "MyExtension" from the publisher "Contoso" and forces the update without any confirmation prompts.

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

### ExtensionState

The state of an installed extension. Example: "disabled". The acceptable values for this parameter are:

- none
- disabled

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
