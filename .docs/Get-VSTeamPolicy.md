<!-- #include "./common/header.md" -->

# Get-VSTeamPolicy

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamPolicy.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamPolicy.md" -->

## EXAMPLES

### Example 1

```powershell
Get-VSTeamPolicy -ProjectName Demo
```

This command returns all the policies for the Demo project in your TFS or Team Services account.

### Example 2

```powershell
Get-VSTeamPolicy -ProjectName Demo -Id 1
```

This command gets the policy with an id of 1 within the Demo project.

## PARAMETERS

### Id

Specifies one code policy by id.

The id is an integer. Unique within each project.

```yaml
Type: Int
Parameter Sets: ByID
Accept pipeline input: true (ByPropertyName)
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

[Get-VSTeamPolicyType](Get-VSTeamPolicyType.md)
