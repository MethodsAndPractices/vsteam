<!-- #include "./common/header.md" -->

# Add-VSTeamUserEntitlement

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamUserEntitlement.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamUserEntitlement.md" -->

## EXAMPLES

### Example 1

```powershell
Add-VSTeamUserEntitlement -License "Advanced" -Group "ProjectAdministrator" -LicensingSource "account" -MSDNLicenseType "professional" -ProjectName "WebAppProject"
```
This command adds a user to the "WebAppProject" with an "Advanced" license type. The user is made a member of the "ProjectAdministrator" group. The licensing source for this user is set as "account" and the MSDN license type is set as "professional".

### Example 2

```powershell
Add-VSTeamUserEntitlement -License "StakeHolder" -Group "ProjectReader" -LicensingSource "msdn" -MSDNLicenseType "enterprise" -ProjectName "MobileAppProject"
```
This example adds a user to the "MobileAppProject" with a "StakeHolder" license type. The user is assigned to the "ProjectReader" group. The licensing source is set to "msdn" and the MSDN license type is "enterprise".

### Example 3

```powershell
Add-VSTeamUserEntitlement -License "Professional" -Group "ProjectContributor" -LicensingSource "profile" -MSDNLicenseType "premium" -ProjectName "BackendServices"
```
In this command, a user is added to the "BackendServices" project with a "Professional" license type. The user is added to the "ProjectContributor" group. The licensing source is set to "profile" and the MSDN license type is "premium".

### Example 4

```powershell
Add-VSTeamUserEntitlement -License "Express" -Group "Custom" -LicensingSource "trial" -MSDNLicenseType "testProfessional" -ProjectName "FrontendUI"
```
This example adds a user to the "FrontendUI" project with an "Express" license type. The user is made a member of a custom group. The licensing source is set as "trial" and the MSDN license type is "testProfessional".

### Example 5

```powershell
Add-VSTeamUserEntitlement -License "None" -Group "ProjectStakeholder" -LicensingSource "none" -MSDNLicenseType "eligible" -ProjectName "DataAnalytics"
```
This command adds a user to the "DataAnalytics" project without assigning any specific license (set to "None"). The user is assigned to the "ProjectStakeholder" group. Both the licensing source and the MSDN license type are set to "none" and "eligible" respectively.

## PARAMETERS

### Email

Email address of the user to add.

```yaml
Type: String
Required: True
Aliases: UserEmail
```

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
