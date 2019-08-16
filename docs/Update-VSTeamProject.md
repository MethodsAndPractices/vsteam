


# Update-VSTeamProject

## SYNOPSIS

Updates the project name, description or both.

## SYNTAX

## DESCRIPTION

Updates the project name, description or both.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Update-VSTeamProject -Name Demo -NewName aspDemo
```

This command changes the name of your project from Demo to aspDemo.

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

### -NewName

The new name for the project.

```yaml
Type: String
```

### -NewDescription

The new description for the project.

```yaml
Type: String
```

### -Id

The id of the project to update.

```yaml
Type: String
Parameter Sets: (ByID)
Aliases: ProjectId
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

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

