


# Remove-VSTeamPolicy

## SYNOPSIS

Removes the specified policy from the specified project.

## SYNTAX

## DESCRIPTION

Remove-VSTeamPolicy removes the policy from the specified project.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Remove-VSTeamPolicy -ProjectName Demo -Id 1
```

This command removes the policy with ID of 1 from the Demo project.

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: 0
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -Id

Specifies one or more policies by ID.

To find the ID of a policy see [Get-VSTeamPolicy](Get-VSTeamPolicy.md)

```yaml
Type: Int[]
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -Force

Forces the function without confirmation

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamPolicy](Add-VSTeamPolicy.md)

[Get-VSTeamPolicy](Get-VSTeamPolicy.md)

[Get-VSTeamPolicyType](Get-VSTeamPolicyType.md)

