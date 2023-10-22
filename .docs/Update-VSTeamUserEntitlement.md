<!-- #include "./common/header.md" -->

# Update-VSTeamUserEntitlement

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamUserEntitlement.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeamUserEntitlement.md" -->

## EXAMPLES

### EXAMPLE 1

```powershell
Update-VSTeamUserEntitlement -Id "12345" -License "Professional"
```

This example updates the license type of a user with ID "12345" to "Professional".

### EXAMPLE 2

```powershell
Update-VSTeamUserEntitlement -Email "user@example.com" -License "StakeHolder"
```

This example updates the license type of a user with email "user@example.com" to "StakeHolder".

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

### LicensingSource

Source of the license. The acceptable values for this parameter are:
- account
- auto
- msdn
- none
- profile
- trial

```yaml
Type: String
Required: False
Parameter Sets: ById, ByEmail
```

### MSDNLicenseType

MSDN license type. The acceptable values for this parameter are:
- eligible
- enterprise
- none
- platforms
- premium
- professional
- testProfessional
- ultimate

```yaml
Type: String
Required: False
Parameter Sets: ById, ByEmail
```

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Get-VSTeamUserEntitlement](Get-VSTeamUserEntitlement.md)
