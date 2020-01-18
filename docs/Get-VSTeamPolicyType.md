


# Get-VSTeamPolicyType

## SYNOPSIS

Get the policy types in the specified Azure DevOps or Team Foundation Server project.

## SYNTAX

## DESCRIPTION

Get the policy types in the specified Azure DevOps or Team Foundation Server project.

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

Specifies one policy type by id.

```yaml
Type: Guid[]
Parameter Sets: ByID
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamPolicy](Add-VSTeamPolicy.md)

[Remove-VSTeamPolicy](Remove-VSTeamPolicy.md)

[Get-VSTeamPolicy](Get-VSTeamPolicy.md)

