


# Add-VSTeamUserEntitlement

## SYNOPSIS

Add a user, assign license and extensions and make them a member of a project group in an account.

## SYNTAX

## DESCRIPTION

Add a user, assign license and extensions and make them a member of a project group in an account.

## EXAMPLES

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

### -LicensingSource

Licensing Source (e.g. Account. MSDN etc.). The acceptable values for this parameter are:

- account
- auto
- msdn
- none
- profile
- trial

```yaml
Type: String
Default value: account
```

### -MSDNLicenseType

Type of MSDN License (e.g. Visual Studio Professional, Visual Studio Enterprise etc.). The acceptable values for this parameter are:

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
Default value: none
```

## INPUTS

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

