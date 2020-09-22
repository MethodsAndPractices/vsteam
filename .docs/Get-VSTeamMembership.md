<!-- #include "./common/header.md" -->

# Get-VSTeamMembership

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamMembership.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamMembership.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamUser | Select-Object -Last 1 | Get-VSTeamMembership | Get-VSTeamGroup
```

Get all the groups for the last user

### Example 2

```powershell
Get-VSTeamGroup | Select-Object -First 1 -Skip 2 | Get-VSTeamMembership | Get-VSTeamUser
```

Get all the members for the third group

## PARAMETERS

### ContainerDescriptor

A container descriptor retrieved by Get-VsTeamGroup

```yaml
Type: String
Required: True
Parameter Sets: ByContainerId
Position: 0
```

### MemberDescriptor

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

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Get-VsTeamUser](Get-VsTeamUser.md)

[Get-VsTeamGroup](Get-VsTeamGroup.md)

[Add-VsTeamMembership](Add-VsTeamMembership.md)

[Remove-VsTeamMembership](Remove-VsTeamMembership.md)

[Test-VsTeamMembership](Test-VsTeamMembership.md)
