---
external help file: Team-Help.xml
Module Name: 
online version: 
schema: 2.0.0
---

# Get-Approval

## SYNOPSIS
Gets a list of approvals for all releases for a team project.

## SYNTAX

```
Get-Approval [-ProjectName] <String> [[-StatusFilter] <String>] [[-ReleaseIdFilter] <Int32[]>]
 [[-AssignedToFilter] <String>]
```

## DESCRIPTION
The Get-Approval function gets the approvals for all releases for a team
project.
The project name is a Dynamic Parameter which may not be displayed
in the syntax above but is mandatory.

With just a project name, this function gets all of the pending approvals
for that team project.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-Approval -ProjectName Demo
```

This command gets a list of all pending approvals.

### -------------------------- EXAMPLE 2 --------------------------
```
Get-Approval -ProjectName Demo -StatusFilter Approved | Format-Table -View Approved
```

This command gets a list of all approved approvals using a custom table format.

### -------------------------- EXAMPLE 3 --------------------------
```
Get-Approval -ProjectName Demo -AssignedToFilter Administrator -StatusFilter Rejected | FT -View Rejected
```

This command gets a list of all approvals rejected by Administrator using a custom table format.

## PARAMETERS

### -StatusFilter
By default the function returns Pending approvals. 
Using this filter you can return Approved, ReAssigned or Rejected approvals. 
There is a custom table view for each status.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReleaseIdFilter
Onlt approvals for the release ids provided will be returned.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssignedToFilter
Approvals are filtered to only those assigned to this user.

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

## INPUTS

### You can pipe build defintion IDs to this function.

## OUTPUTS

### Team.BuildDefinition

## NOTES
This function has a Dynamic Parameter for ProjectName that specifies the
project for which this function gets build definitions.

You can tab complete from a list of avaiable projects.

You can use Set-DefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS

[Add-TeamAccount](Add-TeamAccount.md)
[Set-DefaultProject](Set-DefaultProject.md)
[Add-BuildDefinition](Add-BuildDefinition.md)
[Remove-BuildDefinition](Remove-BuildDefinition.md)

