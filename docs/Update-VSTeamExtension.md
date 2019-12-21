


# Update-VSTeamExtension

## SYNOPSIS

Update an installed extension. Typically this API is used to enable or disable an extension.

## SYNTAX

## DESCRIPTION

Update an installed extension. Typically this API is used to enable or disable an extension.

## EXAMPLES

## PARAMETERS

### -PublisherId

The id of the publisher.

```yaml
Type: String
Required: True
```

### -ExtensionId

The id of the extension.

```yaml
Type: String
Required: True
```

### -ExtensionState

The state of an installed extension. Example: "disabled". The acceptable values for this parameter are:

- none
- disabled

```yaml
Type: String
Required: True
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

## RELATED LINKS

[Add-VSTeamExtension](Add-VSTeamExtension.md)

[Get-VSTeamExtension](Get-VSTeamExtension.md)

[Remove-VSTeamExtension](Remove-VSTeamExtension.md)

[Update-VSTeamExtension](Update-VSTeamExtension.md)

