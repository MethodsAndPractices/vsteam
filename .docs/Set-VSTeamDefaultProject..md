#include "./common/header.md"

# Set-VSTeamDefaultProject

## SYNOPSIS
#include "./synopsis/Set-VSTeamDefaultProject.md"

## SYNTAX

```
Set-VSTeamDefaultProject [-Project] <String> [-Level <String>] [-Force]
```

## DESCRIPTION
The majority of the functions in this module require a project name.

By setting a default project you can omit that parameter from your function 
calls and this default will be used instead.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Set-VSTeamDefaultProject Demo
```

This command sets Demo as the default project.
You can now call other functions that require a project name without passing 
the project.

## PARAMETERS

#include "./params/force.md"

### -Project
Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Level
On Windows allows you to store your default project at the Process, User or 
Machine levels. 

When saved at the User or Machine level your default project will be in any 
future PowerShell processes.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES
Setting a default project also enables tab completion of dynamic parameters 
when you call Add-VSTeamBuild.

## RELATED LINKS