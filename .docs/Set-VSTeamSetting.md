<!-- #include "./common/header.md" -->

# Set-VSTeamSetting

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamSetting.md" -->

## SYNTAX

## Description

Modifies the settings either for the default team in a project, or for a named team if one is specified. Teams can be piped into the command.  Depending on parameters passed it can set the Default and Backlog iterations, the bug behavior (handled as tasks, handled as requirements, or not handled through boards) working days, the team name and the team description

## EXAMPLES


### Example 1

```powershell
Set-VSTeamSetting -ProjectName MyProj -Team 'Planning Team'  -BugsBehavior asTasks -BackLogVisibilites @{Epics=$true} -BacklogIteration CY2020-H2

Name                          Value
----                          -----
Microsoft.EpicCategory        Visible
Custom.Fails                  Hidden
Microsoft.FeatureCategory     Visible
Microsoft.RequirementCategory Visible
Bug display mode              asTasks
Working Days                  monday, tuesday, wednesday, thursday, friday
Default Iteration             Muddy
Backlog Iteration             CY2020
```
This command modifies the team named "Planning Team" in named project, setting  the iteration for Calendar Year 2020, half 2 which is the parent for short sprints over 6 months, sets bugs to be handled as tasks and reveals the Epics backlog using its display name.

### Example 2

```powershell
$it = Get-VSTeamIteration
$settings = Get-VSTeam -Name "planning team" | Set-VSTeamSetting -BacklogIteration $it -BackLogVisibilites @{'Microsoft.EpicCategory'=$false} -raw

```
The first line finds defaukt iteration for the current project.
The second line has a pipeline of two commands - the first finds the team named "Planning Team" in the current project, and the second sets the iteration which was found as the backlog iteration and hides the epics category using its reference name and retuns the updated settings as a single object.


## PARAMETERS

### -BackLogIteration
The new BackLog Iteration, this can be given the iteration's Path, ID, GUID identifier or an object returned by Get-VSTeamIteration.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackLogVisibilites
A hash table where the keys are Backlogs - either by display name like "Epics" or the refernce name like "Microsoft.EpicCategory" - and the values are true or false. The backlogs listed will be hidden or revealed based on the value. If text is used instead of a boolean "False" or "No" will be treated as false (hide) and all other non-empty values will be treated as true (show). Any backlogs not included will be left unchanged

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```


### -BugsBehavior
Set to 'asRequirements' , 'asTasks' or 'off' for "Bugs are managed with requirements", "Bugs are managed with tasks" or "Bugs are not managed on backlogs and boards" respectively.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: asRequirements, asTasks, off

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```


### -DefaultIteration
The new Default Iteration  , this can be given the iteration's Path, ID, GUID identifier or an object returned by Get-VSTeamIteration
```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```


### -Description
A new description for the team

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

### -NewName
A replacement name for the team

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

### -ProjectName
The project containing the team to modified.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RawOutput
If specied returns the object sent back in response to the set request. If not specified as series of name/value pairs a returned for each setting.

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

### -Team
The name of the whose settings should be modified, if no team is specified the project's default team is used. The team can be piped into the command, and doing so will override an value set for projectname.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```


### -WorkingDays
An undated list of the list of working days for the team. Note the full list must be given, "saturday" alone removes the other days.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: monday, tuesday, wednesday, thursday, friday, saturday, sunday

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Get-VSTeamSetting](Get-VSTeamSetting.md)
