#include "./common/header.md"

# Get-Release

## SYNOPSIS
Gets the releases for a team project.

## SYNTAX

### List (Default)
```
Get-Release [-ProjectName] <String> [-Expand <String>] [-StatusFilter <String>] [-DefinitionId <Int32>]
 [-Top <Int32>] [-CreatedBy <String>] [-MinCreatedTime <DateTime>] [-MaxCreatedTime <DateTime>]
 [-QueryOrder <String>] [-ContinuationToken <String>]
```

### ByID
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
PS C:\> Get-Release -ProjectName demo | Format-List *
```

This command gets a list of all release s in the demo project.

The pipeline operator (|) passes the data to the Format-List cmdlet, which
displays all available properties (*) of the release defintion objects.

## PARAMETERS

### -Expand
Specifies which property should be expanded in the list of Release
 (environments, artifacts, none).

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StatusFilter
Draft, Active or Abandoned.

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefinitionId
Id of the release definition

```yaml
Type: Int32
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Top
Specifies the maximum number to return.

```yaml
Type: Int32
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreatedBy

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinCreatedTime

```yaml
Type: DateTime
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxCreatedTime

```yaml
Type: DateTime
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -QueryOrder

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContinuationToken

```yaml
Type: String
Parameter Sets: List
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#include "./params/projectName.md"

### -Id
Specifies one or more releases by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a release defintion, type Get-Release.

```yaml
Type: Int32[]
Parameter Sets: ByID
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

You can tab complete from a list of available projects.

You can use Set-DefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS

[Add-TeamAccount](Add-TeamAccount.md)
[Set-DefaultProject](Set-DefaultProject.md)
[Add-Release](Add-Release.md)
[Remove-Release](Remove-Release.md)