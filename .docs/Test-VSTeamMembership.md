<!-- #include "./common/header.md" -->

# Test-VSTeamMembership

## SYNOPSIS

<!-- #include "./synopsis/Test-VSTeamMembership.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Test-VSTeamMembership.md" -->

## EXAMPLES

### Example 1

```powershell
$UserDescriptor = 'aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj'
$GroupDescriptor = 'vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x'
Test-VSTeamMembership -MemberDescriptor $UserDescriptor -ContainerDescriptor $GroupDescriptor
```
Tests if the user with the email $UserDescriptor is a member of the group $GroupDescriptor.

### Example 2

```powershell
$UserDescriptor = 'aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj'
$GroupDescriptor = 'vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x'
$membershipExists = Test-VSTeamMembership -MemberDescriptor $UserDescriptor -ContainerDescriptor $GroupDescriptor
if ($membershipExists) {
    Write-Output "User is a member of the group."
} else {
    Write-Output "User is not a member of the group."
}
```

Tests if the user with the $UserDescriptor is a member of the group $GroupDescriptor and outputs a message based on the result.

## PARAMETERS

<!-- #include "./params/memberDescriptor.md" -->

<!-- #include "./params/containerDescriptor.md" -->

## INPUTS

## OUTPUTS

### System.Boolean

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Get-VsTeamUser](Get-VsTeamUser.md)

[Get-VsTeamGroup](Get-VsTeamGroup.md)

[Add-VsTeamMembership](Add-VsTeamMembership.md)

[Get-VsTeamMembership](Get-VsTeamMembership.md)

[Remove-VsTeamMembership](Remove-VsTeamMembership.md)
