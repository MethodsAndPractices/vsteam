#include "./common/header.md"

# Remove-VSTeamPolicy

## SYNOPSIS
#include "./synopsis/Remove-VSTeamPolicy.md"

## SYNTAX

```
Remove-VSTeamPolicy [-ProjectName] <String> [-Id <Int[]>] [-Force]
```

## DESCRIPTION
Remove-VSTeamPolicy removes the policy from the specified project.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Remove-VSTeamPolicy -ProjectName Demo -Id 1
```

This command removes the policy with ID of 1 from the Demo project.

## PARAMETERS

#include "./params/projectName.md"

### -Id
Specifies one or more policies by ID.

To find the ID of a policy see [Get-VSTeamPolicy](Get-VSTeamPolicy.md)

```yaml
Type: Int[]
Parameter Sets: (All)
Aliases: None

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

#include "./params/force.md"

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamPolicy](Add-VSTeamPolicy.md)
[Get-VSTeamPolicy](Get-VSTeamPolicy.md)
[Get-VSTeamPolicyType](Get-VSTeamPolicyType.md)