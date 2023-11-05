<!-- #include "./common/header.md" -->

# Update-VSTeamBanner

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamBanner.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeamBanner.md" -->

## EXAMPLES

### Example 1

```powershell
Update-VSTeamBanner -Level warning -Message 'Updated Message' -ExpirationDate '2024-01-01T05:00' -Id '9547ed55-66e1-403d-95aa-9e628726861c'
```

## PARAMETERS

### Level

The level of the banner message. The acceptable values for this parameter are:

- info
- warning
- error

```yaml
Type: String
Required: True
```

### Message

The message content to be displayed on the banner.

```yaml
Type: String
Required: True
```

### ExpirationDate

The expiration date of the banner in the format `yyyy-mm-ddThh:mm`.

```yaml
Type: String
Required: True
```

### Id

The unique identifier for the banner.

```yaml
Type: String
Required: True
```

## INPUTS

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

[Add-VSTeamBanner](Add-VSTeamBanner.md)
[Remove-VSTeamBanner](Remove-VSTeamBanner.md)