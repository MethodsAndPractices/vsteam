


# Get-VSTeamExtension

## SYNOPSIS

Get the installed extensions in the specified Azure DevOps or Team Foundation Server project.

## SYNTAX

## DESCRIPTION

Get the installed extensions in the specified Azure DevOps or Team Foundation Server project.

## EXAMPLES

## PARAMETERS

### -PublisherId

The id of the publisher.

```yaml
Type: String
Required: True
Parameter Sets: GetById
```

### -ExtensionId

The id of the extension.

```yaml
Type: String
Required: True
Parameter Sets: GetById
```

### -IncludeInstallationIssues

If true (the default), include installed extensions with issues.

```yaml
Type: Switch
Parameter Sets: List
```

### -IncludeDisabledExtensions

If true (the default), include disabled extensions in the results.

```yaml
Type: Switch
Parameter Sets: List
```

### -IncludeErrors

If true, include installed extensions with errors.

```yaml
Type: Switch
Parameter Sets: List
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamExtension](Add-VSTeamExtension.md)

[Get-VSTeamExtension](Get-VSTeamExtension.md)

[Remove-VSTeamExtension](Remove-VSTeamExtension.md)

[Update-VSTeamExtension](Update-VSTeamExtension.md)

