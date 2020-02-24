


# Update-VSTeamUserEntitlement

## SYNOPSIS

Edit the entitlements (License, Extensions, Projects, Teams etc) for a user.

## SYNTAX

## DESCRIPTION

Edit the entitlements (License, Extensions, Projects, Teams etc) for a user.

## EXAMPLES

## PARAMETERS

### -Id

The id of the user to be updated.

```yaml
Type: String
Parameter Sets: ById
Required: True
```

### -Email

The email address of the user to update. For organizations with over 100 users this can be very slow and resource intensive.

```yaml
Type: String
Parameter Sets: ByEmail
Required: True
```

### -License

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

[Get-VSTeamUserEntitlement](Get-VSTeamUserEntitlement.md)

