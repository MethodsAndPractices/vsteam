<!-- #include "./common/header.md" -->

# Get-VSTeamUser

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamUser.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamUser.md" -->

## EXAMPLES

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

<!-- #include "./common/related.md" -->
