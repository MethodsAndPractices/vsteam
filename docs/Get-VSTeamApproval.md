


# Get-VSTeamApproval

## SYNOPSIS

Gets a list of approvals for all releases for a team project.

## SYNTAX

## DESCRIPTION

The Get-VSTeamApproval function gets the approvals for all releases for a team project.

With just a project name, this function gets all of the pending approvals for that team project.

When using with AzD "IncludeMyGroupApprovals" will be added to the request when Assigned To Filter is not empty.

When using with TFS "IncludeMyGroupApprovals" will be added to the request when Assigned To Filter, Release Id Filter are not empty and Status Filter equals Pending.

The Team.Approval type has three custom table formats:

- Pending: ID, Status, Release Name, Environment, Type, Approver Name, Release Definitions
- Approved: Release Name, Environment, Is Automated, Approval Type, Approver Name, Release Definitions, Comments
- Rejected: Release Name, Environment, Approval Type, Approver Name, Release Definition, Comments

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamApproval -ProjectName Demo
```

This command gets a list of all pending approvals.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamApproval -ProjectName Demo -StatusFilter Approved | Format-Table -View Approved
```

This command gets a list of all approved approvals using a custom table format.

### -------------------------- EXAMPLE 3 --------------------------

```PowerShell
PS C:\> Get-VSTeamApproval -ProjectName Demo -AssignedToFilter Administrator -StatusFilter Rejected | FT -View Rejected
```

This command gets a list of all approvals rejected by Administrator using a custom table format.

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

### -StatusFilter

By default the function returns Pending approvals.

Using this filter you can return Approved, ReAssigned or Rejected approvals.

There is a custom table view for each status.

```yaml
Type: String
```

### -ReleaseIdsFilter

Only approvals for the release ids provided will be returned.

```yaml
Type: Int32[]
Aliases: ReleaseIdFilter
```

### -AssignedToFilter

Approvals are filtered to only those assigned to this user.

```yaml
Type: String
```

## INPUTS

## OUTPUTS

### Team.BuildDefinition

## NOTES

This function has a Dynamic Parameter for ProjectName that specifies the project for which this function gets build definitions.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have to pass the ProjectName with each call.

You can pipe build definition IDs to this function.

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Set-VSTeamDefaultProject](Set-VSTeamDefaultProject.md)

[Add-VSTeamBuildDefinition](Add-VSTeamBuildDefinition.md)

[Remove-VSTeamBuildDefinition](Remove-VSTeamBuildDefinition.md)

