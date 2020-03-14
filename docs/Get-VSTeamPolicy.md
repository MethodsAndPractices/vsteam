


# Get-VSTeamPolicy

## SYNOPSIS

Get the code policies in the specified Azure DevOps or Team Foundation Server project.

## SYNTAX

## DESCRIPTION

Get the code policies in the specified Azure DevOps or Team Foundation Server project.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamPolicy -ProjectName Demo
```

This command returns all the policies for the Demo project in your TFS or Team Services account.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamPolicy -ProjectName Demo -Id 1
```

This command gets the policy with an id of 1 within the Demo project.

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

Specifies one code policy by id.

The id is an integer. Unique within each project.

```yaml
Type: Int
Parameter Sets: ByID
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamPolicy](Add-VSTeamPolicy.md)

[Remove-VSTeamPolicy](Remove-VSTeamPolicy.md)

[Get-VSTeamPolicyType](Get-VSTeamPolicyType.md)

