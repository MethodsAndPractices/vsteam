


# Add-VSTeamMembership

## SYNOPSIS

Adds a membership to a container.

## SYNTAX

## DESCRIPTION

Adds a membership to a container.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> $user = Get-VSTeamUser | ? DisplayName -eq 'Test User'
PS C:\> $group = Get-VSTeamGroup | ? DisplayName -eq 'Endpoint Administrators'
PS C:\> Add-VSTeamMembership -MemberDescriptor $user.Descriptor -ContainerDescriptor $group.Descriptor
```

Adds Test User to the Endpoint Administrators group.

## PARAMETERS

### -MemberDescriptor

A member descriptor retrieved by Get-VsTeamUser

```yaml
Type: String
Required: True
Position: 0
```


### -ContainerDescriptor

A container descriptor retrieved by Get-VsTeamGroup

```yaml
Type: String
Required: True
Position: 1
```


## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-VsTeamUser](Get-VsTeamUser.md)

[Get-VsTeamGroup](Get-VsTeamGroup.md)

[Get-VsTeamMembership](Get-VsTeamMembership.md)

[Remove-VsTeamMembership](Remove-VsTeamMembership.md)

[Test-VsTeamMembership](Test-VsTeamMembership.md)

