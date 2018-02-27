#include "./common/header.md"

# Add-VSTeamPolicy

## SYNOPSIS
#include "./synopsis/Add-VSTeamPolicy.md"

## SYNTAX

### To a project (Default)
```
Add-VSTeamPolicy -ProjectName <String> -type [guid] [-enabled] [-blocking] -settings [hashtable]
```

## DESCRIPTION
#include "./synopsis/Add-VSTeamPolicy.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Add-VSTeamPolicy -ProjectName Demo -type 687c53f8-1a82-4e89-9a86-13d51bc4a8d5 -enabled -blocking -settings @{MinimumApproverCount = 1;Scope=@(@{repositoryId=b87c5af8-1a82-4e59-9a86-13d5cbc4a8d5; matchKind="Exact"; refName="refs/heads/master"})}
```

This command adds a new policy to the Demo project's repository specified. The policy added requires a minimum number of reviewers and applies to the master branch. Specifying `-blocking` will block pushes to master directly.

## PARAMETERS

#include "./params/projectName.md"

### -type
Specifies the id of the type of policy to be created.

```yaml
Type: Guid
Parameter Sets: (All)

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -enabled
Enables the policy

```yaml
Type: Boolean
Parameter Sets: (All)

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```


### -blocking
Determines if the policy will block pushes to the branch if the policy is not adheared to.

```yaml
Type: Boolean
Parameter Sets: (All)

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```


### -settings
The settings for the policy.

Each policy type has it's own settings that will need to be set.

```yaml
Type: Hashtable
Parameter Sets: (All)

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-VSTeamPolicy](Get-VSTeamPolicy.md)
[Remove-VSTeamPolicy](Remove-VSTeamPolicy.md)
[Get-VSTeamPolicyType](Get-VSTeamPolicyType.md)