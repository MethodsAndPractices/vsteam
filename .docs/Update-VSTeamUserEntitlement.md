<!-- #include "./common/header.md" -->

# Update-VSTeamUserEntitlement

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamUserEntitlement.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeamUserEntitlement.md" -->

## EXAMPLES

## PARAMETERS

### Id

The id of the user to be updated.

```yaml
Type: String
Parameter Sets: ById
Required: True
```

### Email

The email address of the user to update. For organizations with over 100 users this can be very slow and resource intensive.

```yaml
Type: String
Parameter Sets: ByEmail
Required: True
```

### License

Type of Account License you want to change to. The acceptable values for this parameter are:

- Advanced
- EarlyAdopter
- Express
- None
- Professional
- StakeHolder

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

<!-- #include "./common/related.md" -->

[Get-VSTeamUserEntitlement](Get-VSTeamUserEntitlement.md)
