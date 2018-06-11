#include "./common/header.md"

# Get-VSTeamPolicyType

## SYNOPSIS

#include "./synopsis/Get-VSTeamPolicyType.md"

## SYNTAX

### All in project (Default)

```PowerShell
Get-VSTeamPolicyType -ProjectName <String>
```

### ById

```PowerShell
Get-VSTeamPolicyType -ProjectName <String> [-Id <Guid>]
```

## DESCRIPTION

#include "./synopsis/Get-VSTeamPolicyType.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamPolicyType -ProjectName Demo
```

This command returns all the policy types for the Demo project.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Get-VSTeamPolicyType -ProjectName Demo -Id 73da726a-8ff9-44d7-8caa-cbb581eac991
```

This command gets the policy type by the specified id within the Demo project.

## PARAMETERS

#include "./params/projectName.md"

### -Id

Specifies one policy type by id.

```yaml
Type: Guid[]
Parameter Sets: ByID

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamPolicy](Add-VSTeamPolicy.md)
[Remove-VSTeamPolicy](Remove-VSTeamPolicy.md)
[Get-VSTeamPolicy](Get-VSTeamPolicy.md)