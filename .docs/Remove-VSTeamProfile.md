<!-- #include "./common/header.md" -->

# Remove-VSTeamProfile

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamProfile.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamProfile.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamProfile | Remove-VSTeamProfile -Force
```

This will remove all the profiles on your system.

## PARAMETERS

### Name

Name of profile to remove.

```yaml
Type: String
Required: True
```

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

[Add-VSTeamProfile](Add-VSTeamProfile.md)

[Set-VSTeamAPIVersion](Set-VSTeamAPIVersion.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Set-VSTeamDefaultAPITimeout](Set-VSTeamDefaultAPITimeout.md)

[about_vsteam](about_vsteam)

[about_vsteam_profiles](about_vsteam_profiles)

[about_vsteam_provider](about_vsteam_provider)
