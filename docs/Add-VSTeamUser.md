


# Add-VSTeamUser

## SYNOPSIS

Adds a user to the account.

## SYNTAX

## DESCRIPTION

Adds a user to the account.

## EXAMPLES

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Required: true
Position: 0
Accept pipeline input: true (ByPropertyName)
```

### -License

Type of Account License. The acceptable values for this parameter are:

- Advanced
- EarlyAdopter
- Express
- None
- Professional
- StakeHolder

```yaml
Type: String
Required: True
Default value: EarlyAdopter
```

### -Group

The acceptable values for this parameter are:

- Custom
- ProjectAdministrator
- ProjectContributor
- ProjectReader
- ProjectStakeholder

```yaml
Type: String
Required: True
Default value: ProjectContributor
```

## INPUTS

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS