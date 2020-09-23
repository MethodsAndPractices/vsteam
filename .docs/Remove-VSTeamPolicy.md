<!-- #include "./common/header.md" -->

# Remove-VSTeamPolicy

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamPolicy.md" -->

## SYNTAX

## DESCRIPTION

Remove-VSTeamPolicy removes the policy from the specified project.

## EXAMPLES

### Example 1

```powershell
Remove-VSTeamPolicy -ProjectName Demo -Id 1
```

This command removes the policy with ID of 1 from the Demo project.

## PARAMETERS

### Id

Specifies one or more policies by ID.

To find the ID of a policy see [Get-VSTeamPolicy](Get-VSTeamPolicy.md)

```yaml
Type: Int[]
Required: True
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamPolicy](Add-VSTeamPolicy.md)

[Get-VSTeamPolicy](Get-VSTeamPolicy.md)

[Get-VSTeamPolicyType](Get-VSTeamPolicyType.md)
