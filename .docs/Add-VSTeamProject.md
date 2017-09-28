#include "./common/header.md"

# Add-VSTeamProject

## SYNOPSIS
#include "./synopsis/Add-VSTeamProject.md"

## SYNTAX

```
Add-VSTeamProject [-ProjectName] <String> [[-ProcessTemplate] <String>] [[-Description] <String>] [-TFVC]
```

## DESCRIPTION
This will create a new Team Project in your Team Foundation Server or Team Services
account.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Add-VSTeamProject 'MyProject'
```

This will add a project name MyProject with no description using the Scrum process
template and Git source control.

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Add-VSTeamProject 'MyProject' -TFVC -ProcessTemplate Agile
```

This will add a project name MyProject with no description using the Agile process
template and TFVC source control.

## PARAMETERS

### -ProjectName
The name of the project to create.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProcessTemplate
The name of the process template to use for the project.
The valid values are
Agile, Scrum or CMMI.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: Scrum
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description of the team project.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TFVC
Switches the source control from Git to TFVC.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Remove-VSTeamProject](Remove-VSTeamProject.md)