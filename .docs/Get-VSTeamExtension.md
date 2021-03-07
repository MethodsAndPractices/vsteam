<!-- #include "./common/header.md" -->

# Get-VSTeamExtension

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamExtension.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamExtension.md" -->

## EXAMPLES

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

<!-- #include "./common/related.md" -->

[Add-VSTeamExtension](Add-VSTeamExtension.md)

[Get-VSTeamExtension](Get-VSTeamExtension.md)

[Remove-VSTeamExtension](Remove-VSTeamExtension.md)

[Update-VSTeamExtension](Update-VSTeamExtension.md)
