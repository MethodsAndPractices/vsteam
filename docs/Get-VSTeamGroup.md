


# Get-VSTeamGroup

## SYNOPSIS

Returns a Group or List of Groups.

## SYNTAX

## DESCRIPTION

Returns a Group or List of Groups.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> $group = Get-VSTeamGroup | ? DisplayName -eq 'Endpoint Administrators'
```

Assigns Endpoint Administrators group to $group variable.

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: 0
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -SubjectTypes

A comma separated list of user subject subtypes to reduce the retrieved results.
Valid subject types:

- vssgp (Azure DevOps Group)
- aadgp (Azure Active Directory Group)

```yaml
Type: String[]
Required: False
Parameter Sets: List, ListByProjectName
```

### -ScopeDescriptor

Specify a non-default scope (collection, project) to search for groups.

```yaml
Type: String
Required: False
Parameter Sets: List
```

### -Descriptor

The descriptor of the desired graph group.

```yaml
Type: String
Required: False
Parameter Sets: ByGroupDescriptor
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

