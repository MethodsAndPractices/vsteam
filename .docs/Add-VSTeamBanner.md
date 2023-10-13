<!-- #include "./common/header.md" -->

# Add-VSTeamBanner

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamBanner.md" -->

## SYNTAX

```powershell
Add-VSTeamBanner -Level <String> -Message <String> -ExpirationDate <String> -BannerId <String>
```

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamBanner.md" -->

## EXAMPLES

```powershell
Add-VSTeamBanner -Level info -Message 'Test Message' -ExpirationDate '2024-01-01T04:00' -BannerId '9547ed55-66e1-403d-95aa-9e628726861c'
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

### BannerId

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

[Remove-VSTeamBanner](Remove-VSTeamBanner.md)
[Update-VSTeamBanner](Update-VSTeamBanner.md)