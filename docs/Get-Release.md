---
external help file: Team-Help.xml
Module Name: 
online version: 
schema: 2.0.0
---

# Get-Release

## SYNOPSIS
Gets the releases for a team project.

## SYNTAX

### UNNAMED_PARAMETER_SET_1
```
Get-Release [-ProjectName] <String> [-Expand <String>] [-StatusFilter <String>] [-DefinitionId <Int32>]
 [-Top <Int32>] [-CreatedBy <String>] [-MinCreatedTime <DateTime>] [-MaxCreatedTime <DateTime>]
 [-QueryOrder <String>] [-ContinuationToken <String>]
```

### UNNAMED_PARAMETER_SET_2
```
Get-Release [-ProjectName] <String> [-Id <Int32[]>]
```

## DESCRIPTION
The Get-Release function gets the releases for a team
project.
The project name is a Dynamic Parameter which may not be displayed
in the syntax above but is mandatory.

With just a project name, this function gets all of the release s
for that team project.
You can also specify a particular release defintion
by ID.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-Release -ProjectName demo | Format-List *
```

This command gets a list of all release s in the demo project.
The
pipeline operator (|) passes the data to the Format-List cmdlet, which
displays all available properties (*) of the release defintion objects.

## PARAMETERS

### -Expand
Specifies which property should be expanded in the list of Release
 (environments, artifacts, none).

```yaml
Type: String
Parameter Sets: UNNAMED_PARAMETER_SET_1
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StatusFilter
@{Text=}

```yaml
Type: String
Parameter Sets: UNNAMED_PARAMETER_SET_1
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefinitionId
@{Text=}

```yaml
Type: Int32
Parameter Sets: UNNAMED_PARAMETER_SET_1
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Top
@{Text=}

```yaml
Type: Int32
Parameter Sets: UNNAMED_PARAMETER_SET_1
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreatedBy
@{Text=}

```yaml
Type: String
Parameter Sets: UNNAMED_PARAMETER_SET_1
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinCreatedTime
@{Text=}

```yaml
Type: DateTime
Parameter Sets: UNNAMED_PARAMETER_SET_1
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxCreatedTime
@{Text=}

```yaml
Type: DateTime
Parameter Sets: UNNAMED_PARAMETER_SET_1
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -QueryOrder
@{Text=}

```yaml
Type: String
Parameter Sets: UNNAMED_PARAMETER_SET_1
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContinuationToken
@{Text=}

```yaml
Type: String
Parameter Sets: UNNAMED_PARAMETER_SET_1
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectName
Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-DefaultProject to set a default project so
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

### -Id
Specifies one or more releases by ID.
To specify multiple IDs, use
commas to separate the IDs.
To find the ID of a release defintion, type
Get-Release.

```yaml
Type: Int32[]
Parameter Sets: UNNAMED_PARAMETER_SET_2
Aliases: ReleaseID

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

### You can pipe release defintion IDs to this function.

## OUTPUTS

### Team.Release

## NOTES
This function has a Dynamic Parameter for ProjectName that specifies the
project for which this function gets release s.

You can tab complete from a list of avaiable projects.

You can use Set-DefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS

[Add-TeamAccount](Add-TeamAccount.md)
[Set-DefaultProject](Set-DefaultProject.md)
[Add-Release](Add-Release.md)
[Remove-Release](Remove-Release.md)

