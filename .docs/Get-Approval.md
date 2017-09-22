#include "./common/header.md"

# Get-Approval

## SYNOPSIS
#include "./synopsis/Get-Approval.md"

## SYNTAX

```
Get-Approval [-ProjectName] <String> [[-StatusFilter] <String>] [[-ReleaseIdFilter] <Int32[]>]
 [[-AssignedToFilter] <String>]
```

## DESCRIPTION
The Get-Approval function gets the approvals for all releases for a team
project.

With just a project name, this function gets all of the pending approvals
for that team project.

The Team.Approval type has three custom table formats:

Pending: ID, Status, Release Name, Environment, Type, Approver Name, Release Definitions

Approved: Release Name, Environment, Is Automated, Approval Type, Approver Name, Release Definitions, Comments

Rejected: Release Name, Environment, Approval Type, Approver Name, Release Definition, Comments

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-Approval -ProjectName Demo
```

This command gets a list of all pending approvals.

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Get-Approval -ProjectName Demo -StatusFilter Approved | Format-Table -View Approved
```

This command gets a list of all approved approvals using a custom table format.

### -------------------------- EXAMPLE 3 --------------------------
```
PS C:\> Get-Approval -ProjectName Demo -AssignedToFilter Administrator -StatusFilter Rejected | FT -View Rejected
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
Only approvals for the release ids provided will be returned.

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

#include "./params/projectName.md"

## INPUTS

### You can pipe build defintion IDs to this function.

## OUTPUTS

### Team.BuildDefinition

## NOTES
This function has a Dynamic Parameter for ProjectName that specifies the
project for which this function gets build definitions.

You can tab complete from a list of available projects.

You can use Set-DefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)
[Set-DefaultProject](Set-DefaultProject.md)
[Add-BuildDefinition](Add-BuildDefinition.md)
[Remove-BuildDefinition](Remove-BuildDefinition.md)