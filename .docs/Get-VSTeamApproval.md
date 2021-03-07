<!-- #include "./common/header.md" -->

# Get-VSTeamApproval

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamApproval.md" -->

## SYNTAX

## DESCRIPTION

The Get-VSTeamApproval function gets the approvals for all releases for a team project.

With just a project name, this function gets all of the pending approvals for that team project.

When using with AzD "IncludeMyGroupApprovals" will be added to the request when Assigned To Filter is not empty.

When using with TFS "IncludeMyGroupApprovals" will be added to the request when Assigned To Filter, Release Id Filter are not empty and Status Filter equals Pending.

The vsteam_lib.Approval type has three custom table formats:

- Pending: ID, Status, Release Name, Environment, Type, Approver Name, Release Definitions
- Approved: Release Name, Environment, Is Automated, Approval Type, Approver Name, Release Definitions, Comments
- Rejected: Release Name, Environment, Approval Type, Approver Name, Release Definition, Comments

## EXAMPLES

### Example 1

```powershell
Get-VSTeamApproval -ProjectName Demo
```

This command gets a list of all pending approvals.

### Example 2

```powershell
Get-VSTeamApproval -ProjectName Demo -StatusFilter Approved | Format-Table -View Approved
```

This command gets a list of all approved approvals using a custom table format.

### Example 3

```powershell
Get-VSTeamApproval -ProjectName Demo -AssignedToFilter Administrator -StatusFilter Rejected | FT -View Rejected
```

This command gets a list of all approvals rejected by Administrator using a custom table format.

## PARAMETERS

### StatusFilter

By default the function returns Pending approvals.

Using this filter you can return Approved, ReAssigned or Rejected approvals.

There is a custom table view for each status.

```yaml
Type: String
```

### ReleaseId

Only approvals for the release ids provided will be returned.

```yaml
Type: Int32[]
```

### AssignedToFilter

Approvals are filtered to only those assigned to this user.

```yaml
Type: String
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### vsteam_lib.BuildDefinition

## NOTES

You can pipe build definition IDs to this function.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamBuildDefinition](Add-VSTeamBuildDefinition.md)

[Remove-VSTeamBuildDefinition](Remove-VSTeamBuildDefinition.md)
