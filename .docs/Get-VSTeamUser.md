<!-- #include "./common/header.md" -->

# Get-VSTeamUser

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamUser.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamUser.md" -->

## EXAMPLES

### Example 1
```powershell
Get-VSTeamUser
```

Returns a list of all users for the account.

### Example 2
```powershell
Get-VSTeamUser -SubjectTypes vss,msa
```

Returns a list of users for the account filtered by the specified subject types: Azure DevOps User (vss) and Microsoft Account (msa).

### Example 3
```powershell
Get-VSTeamUser -Descriptor "vssA1B2C3D4E5F6"
```

Returns the user with the specified descriptor "vssA1B2C3D4E5F6".

## PARAMETERS

### SubjectTypes

A comma separated list of user subject subtypes to reduce the retrieved results.
Valid subject types:

- vss (Azure DevOps User)
- aad (Azure Active Directory User)
- svc (Azure DevOps Service Identity)
- imp (Imported Identity)
- msa (Microsoft Account)

```yaml
Type: String[]
Required: False
Parameter Sets: List
```

### Descriptor

The descriptor of the desired graph user.

```yaml
Type: String
Required: False
Parameter Sets: ByUserDescriptor
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
