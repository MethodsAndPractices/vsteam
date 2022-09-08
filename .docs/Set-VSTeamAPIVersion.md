<!-- #include "./common/header.md" -->

# Set-VSTeamAPIVersion

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamAPIVersion.md" -->

## SYNTAX

## DESCRIPTION

Set-VSTeamAPIVersion sets the versions of APIs used.

## EXAMPLES

### Example 1

```powershell
Set-VSTeamAPIVersion AzD
```

This command sets the API versions to support AzD.

### Example 2

```powershell
Set-VSTeamAPIVersion -Service Release -Version '5.0'
```

This command sets the version of the Release calls to 5.0.

## PARAMETERS

### Target

Specifies the version to use. The acceptable values for this parameter are:

- AzD2019
- AzD2019U1
- VSTS
- AzD

```yaml
Type: String
Required: True
Position: 0
Parameter Sets: Target
Default value: AzD2019
```

### Service

Specifies the service to change. The acceptable values for this parameter are:

- Build
- Release
- Core
- Git
- DistributedTask
- Tfvc
- Packaging
- MemberEntitlementManagement
- ExtensionsManagement
- ServiceEndpoints

```yaml
Type: String
Required: True
Parameter Sets: Service
```

### Version

Specifies the version to use.

```yaml
Type: String
Required: True
Parameter Sets: Service
```

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

[Set-VSTeamAPIVersion](Set-VSTeamAPIVersion.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Set-VSTeamDefaultAPITimeout](Set-VSTeamDefaultAPITimeout.md)

[about_vsteam](about_vsteam)

[about_vsteam_profiles](about_vsteam_profiles)

[about_vsteam_provider](about_vsteam_provider)
