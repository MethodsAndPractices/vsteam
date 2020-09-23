<!-- #include "./common/header.md" -->

# Get-VSTeamPolicyType

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamPolicyType.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamPolicyType.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamPolicyType -ProjectName Demo
```

This command returns all the policy types for the Demo project.

### Example 3

```powershell
Get-VSTeamPolicyType -ProjectName Demo -Id 73da726a-8ff9-44d7-8caa-cbb581eac991
```

This command gets the policy type by the specified id within the Demo project.

## PARAMETERS

### Id

Specifies one policy type by id.

```yaml
Type: Guid[]
Parameter Sets: ByID
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamPolicy](Add-VSTeamPolicy.md)

[Remove-VSTeamPolicy](Remove-VSTeamPolicy.md)

[Get-VSTeamPolicy](Get-VSTeamPolicy.md)
