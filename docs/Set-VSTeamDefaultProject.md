


# Set-VSTeamDefaultProject

## SYNOPSIS

Sets the default project to be used with other calls in the module.

## SYNTAX

## DESCRIPTION

The majority of the functions in this module require a project name.

By setting a default project you can omit that parameter from your function calls and this default will be used instead.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Set-VSTeamDefaultProject Demo
```

This command sets Demo as the default project.

You can now call other functions that require a project name without passing the project.

## PARAMETERS

### -Force

Forces the function without confirmation

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
```

### -Project

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have to pass the ProjectName with each call.

```yaml
Type: String
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -Level

On Windows allows you to store your default project at the Process, User or Machine levels.

When saved at the User or Machine level your default project will be in any future PowerShell processes.

```yaml
Type: String
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

Setting a default project also enables tab completion of dynamic parameters when you call Add-VSTeamBuild.

## RELATED LINKS

