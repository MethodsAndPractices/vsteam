<!-- #include "./common/header.md" -->

# Add-VSTeamMembership

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamMembership.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamMembership.md" -->

## EXAMPLES

### Example 1

```powershell
$user = Get-VSTeamUser | ? DisplayName -eq 'Test User'
$group = Get-VSTeamGroup | ? DisplayName -eq 'Endpoint Administrators'
Add-VSTeamMembership -MemberDescriptor $user.Descriptor -ContainerDescriptor $group.Descriptor
```

Adds Test User to the Endpoint Administrators group.

## PARAMETERS

<!-- #include "./params/memberDescriptor.md" -->

<!-- #include "./params/containerDescriptor.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Get-VsTeamUser](Get-VsTeamUser.md)

[Get-VsTeamGroup](Get-VsTeamGroup.md)

[Get-VsTeamMembership](Get-VsTeamMembership.md)

[Remove-VsTeamMembership](Remove-VsTeamMembership.md)

[Test-VsTeamMembership](Test-VsTeamMembership.md)
