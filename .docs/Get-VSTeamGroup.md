<!-- #include "./common/header.md" -->

# Get-VSTeamGroup

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamGroup.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamGroup.md" -->

## EXAMPLES

### Example 1

```powershell
$group = Get-VSTeamGroup | ? DisplayName -eq 'Endpoint Administrators'
```

Assigns Endpoint Administrators group to $group variable.

## PARAMETERS

### SubjectTypes

A comma separated list of user subject subtypes to reduce the retrieved results.
Valid subject types:

- vssgp (Azure DevOps Group)
- aadgp (Azure Active Directory Group)

```yaml
Type: String[]
Required: False
Parameter Sets: List, ListByProjectName
```

### ScopeDescriptor

Specify a non-default scope (collection, project) to search for groups.

```yaml
Type: String
Required: False
Parameter Sets: List
```

### Descriptor

The descriptor of the desired graph group.

```yaml
Type: String
Required: False
Parameter Sets: ByGroupDescriptor
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
