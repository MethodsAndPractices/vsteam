<!-- #include "./common/header.md" -->

# Set-VSTeamProcess

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamProcess.md" -->

## SYNTAX

### LeaveAlone (Default)
```
Set-VSTeamProcess -ProcessTemplate <Object> [-Description <String>] [-NewName <String>] [-AsDefault] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Hide
```
Set-VSTeamProcess -ProcessTemplate <Object> [-Description <String>] [-NewName <String>] [-Disabled] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Show
```
Set-VSTeamProcess -ProcessTemplate <Object> [-Description <String>] [-NewName <String>] [-Enabled] [-AsDefault]
 [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Set-VSTeamProcess will enable/disable precesses, rename them, change their description and set a process as the default for new projects. The command will prompt for confirmation, unless used with the -Force switch 

## EXAMPLES

### EXAMPLE 1

```PowerShell
PS C:\> Set-VSTeamProcess -name Agile -AsDefault

Confirm
Are you sure you want to perform this action?
Performing the operation "Update Devops Process" on target "Agile".
[Y] Yes [A] Yes to All [N] No [L] No to All [S] Suspend [?] Help (default is "Yes"): y

Name        : Agile
ID          : adcc42ab-9882-485e-a3ed-7678f01f66bc
Description : This template is flexible and will work great for most teams using Agile planning methods, including those practicing Scrum.
IsEnabled   : True
IsDefault   : True
```

This commands sets the built-in process "Agile" as the default process, and waits for the user to confirm the action.

### EXAMPLE 2

```PowerShell
PS C:\> Get-VSTeamProcess -Name Basic | Set-VSTeamProcess -Disabled -Force

Name        : Basic
ID          : b8a3a935-7e91-48b8-a94c-606d37c3e9f2
Description : This template is flexible for any process and great for teams getting started with Azure DevOps.
IsEnabled   : False
IsDefault   : False
```

The first command in the pipeline gets built-in process "Basic", and the second disables it without waiting for confirmation. 

The Get- command could take a wildcard and return multiple matching processes which would all be disabled.

### EXAMPLE 3

```PowerShell
PS C:\> Set-VSTeamProcess -ProcessTemplate 'Basic J' -NewName 'Basic-J' -Description 'Template for the Mysterious J Project' -Force


Name    Enabled Default Description
----    ------- ------- -----------
Basic-J True    False   Template for the Mysterious J Project
```

This renames a project to remove the space from its name and gives it a new description.

## PARAMETERS

### -Description

The Description of the new process

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

### -AsDefault

Makes a process the default for the Organization

```yaml
Type: SwitchParameter
Parameter Sets: LeaveAlone, Show
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Disabled

Disables a process; built-in processes cannot be deleted.

```yaml
Type: SwitchParameter
Parameter Sets: Hide
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enabled

Re-enables a disabled Process

```yaml
Type: SwitchParameter
Parameter Sets: Show
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force

Prevents the confirmation prompt appearing.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName

Allows the Process to be renamed

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

### -ProcessTemplate
{{ Fill ProcessTemplate Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Name

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
