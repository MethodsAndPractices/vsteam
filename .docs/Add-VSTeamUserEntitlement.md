<!-- #include "./common/header.md" -->

# Add-VSTeamUserEntitlement

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamUserEntitlement.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamUserEntitlement.md" -->

## EXAMPLES

## PARAMETERS

### License

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

### Group

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

### LicensingSource

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

### MSDNLicenseType

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

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
