<!-- #include "./common/header.md" -->

# Get-VSTeamExtension

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamExtension.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamExtension.md" -->

## EXAMPLES

### Example 1
```powershell
Get-VSTeamExtension -PublisherId 'PublisherA' -ExtensionId 'Ext123'
```

This command retrieves the details of the extension with the id 'Ext123' from the publisher with id 'PublisherA'.

### Example 2
```powershell
Get-VSTeamExtension -IncludeInstallationIssues
```

This command retrieves all installed extensions and includes those with installation issues in the results.

### Example 3
```powershell
Get-VSTeamExtension -IncludeDisabledExtensions
```

This command retrieves all installed extensions, including those that are currently disabled.

### Example 4
```powershell
Get-VSTeamExtension -IncludeErrors
```

This command retrieves all installed extensions and includes those with errors in the results.

### Example 5
```powershell
Get-VSTeamExtension | Where-Object { $_.PublisherId -eq 'PublisherA' }
```

This command retrieves all installed extensions and then filters out to display only those from the publisher with id 'PublisherA'.

## PARAMETERS

### PublisherId

The id of the publisher.

```yaml
Type: String
Required: True
Parameter Sets: GetById
```

### ExtensionId

The id of the extension.

```yaml
Type: String
Required: True
Parameter Sets: GetById
```

### IncludeInstallationIssues

If true (the default), include installed extensions with issues.

```yaml
Type: Switch
Parameter Sets: List
```

### IncludeDisabledExtensions

If true (the default), include disabled extensions in the results.

```yaml
Type: Switch
Parameter Sets: List
```

### IncludeErrors

If true, include installed extensions with errors.

```yaml
Type: Switch
Parameter Sets: List
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Add-VSTeamExtension](Add-VSTeamExtension.md)

[Get-VSTeamExtension](Get-VSTeamExtension.md)

[Remove-VSTeamExtension](Remove-VSTeamExtension.md)

[Update-VSTeamExtension](Update-VSTeamExtension.md)
