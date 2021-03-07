<!-- #include "./common/header.md" -->

# Add-VSTeamPolicy

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamPolicy.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamPolicy.md" -->

## EXAMPLES

### Example 1

```powershell
Add-VSTeamPolicy -ProjectName Demo -type 687c53f8-1a82-4e89-9a86-13d51bc4a8d5 -enabled -blocking -settings @{MinimumApproverCount = 1;Scope=@(@{repositoryId=b87c5af8-1a82-4e59-9a86-13d5cbc4a8d5; matchKind="Exact"; refName="refs/heads/trunk"})}
```

This command adds a new policy to the Demo project's repository specified. The policy added requires a minimum number of reviewers and applies to the trunk branch. Specifying `-blocking` will block pushes to trunk directly.

## PARAMETERS

### type

Specifies the id of the type of policy to be created.

```yaml
Type: Guid
Required: True
```

### enabled

Enables the policy

```yaml
Type: Switch
```

### blocking

Determines if the policy will block pushes to the branch if the policy is not adhered to.

```yaml
Type: Switch
```

### settings

The settings for the policy.

Each policy type has it's own settings that will need to be set.

```yaml
Type: Hashtable
Required: True
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Get-VSTeamPolicy](Get-VSTeamPolicy.md)

[Remove-VSTeamPolicy](Remove-VSTeamPolicy.md)

[Get-VSTeamPolicyType](Get-VSTeamPolicyType.md)
