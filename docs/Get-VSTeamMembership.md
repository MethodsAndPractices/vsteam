


# Get-VSTeamMembership

## SYNOPSIS

Gets a memberships for a container or member.

## SYNTAX

## DESCRIPTION

Gets a memberships for a container or member.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
(Get-VSTeamMembership -MemberDescriptor $user.ID).value | % { Get-VSTeamGroup -Descriptor $_.containerDescriptor }
```

Get all the groups for a user

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
(Get-VSTeamMembership -ContainerDescriptor $group.id).value | % {Get-VSTeamUser -Descriptor $_.memberDescriptor }
```

Get all the members for a group

## PARAMETERS

### -ContainerDescriptor

A container descriptor retrieved by Get-VsTeamGroup

```yaml
Type: String
Required: True
Parameter Sets: ByContainerId
Position: 0
```

### -MemberDescriptor

A member descriptor retrieved by Get-VsTeamUser

```yaml
Type: String
Required: True
Parameter Sets: ByMemberId
Position: 0
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-VsTeamUser](Get-VsTeamUser.md)

[Get-VsTeamGroup](Get-VsTeamGroup.md)

[Add-VsTeamMembership](Add-VsTeamMembership.md)

[Remove-VsTeamMembership](Remove-VsTeamMembership.md)

[Test-VsTeamMembership](Test-VsTeamMembership.md)

