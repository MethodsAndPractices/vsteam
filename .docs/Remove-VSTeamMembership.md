<!-- #include "./common/header.md" -->

# Remove-VSTeamMembership

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamMembership.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamMembership.md" -->

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> $user = Get-VSTeamUser | ? DisplayName -eq 'Test User'
PS C:\> $group = Get-VSTeamGroup | ? DisplayName -eq 'Endpoint Administrators'
PS C:\> Remove-VSTeamMembership -MemberDescriptor $user.Descriptor -ContainerDescriptor $group.Descriptor
```

Removes Test User from the Endpoint Administrators group.

## PARAMETERS

<!-- #include "./params/memberDescriptor.md" -->

<!-- #include "./params/containerDescriptor.md" -->

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-VsTeamUser](Get-VsTeamUser.md)

[Get-VsTeamGroup](Get-VsTeamGroup.md)

[Add-VsTeamMembership](Add-VsTeamMembership.md)

[Get-VsTeamMembership](Get-VsTeamMembership.md)

[Test-VsTeamMembership](Test-VsTeamMembership.md)
