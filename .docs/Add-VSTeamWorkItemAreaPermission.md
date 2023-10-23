<!-- #include "./common/header.md" -->

# Add-VSTeamWorkItemAreaPermission

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamWorkItemAreaPermission.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamWorkItemAreaPermission.md" -->

## EXAMPLES

### Example 1

```powershell
Add-VSTeamWorkItemAreaPermission -AreaID 201 -AreaPath "Features\Authentication" -Descriptor "vssgp.User1D3nt1f13r" -User "vssa.User1D3nt1f13r" -Group "vssgp.Group1D3nt1f13r" -Allow "Read,Write" -Deny "Delete" -ProjectName "WebAppProject"
```
This command adds read and write permissions to the work item area with ID 201 and path "Features\Authentication" for a user with the descriptor "vssa.User1D3nt1f13r" and a group with the descriptor "vssgp.Group1D3nt1f13r" in the "WebAppProject". It denies the delete permission for the same.

### Example 2

```powershell
Add-VSTeamWorkItemAreaPermission -AreaID 202 -AreaPath "Features\Registration" -Descriptor "vssgp.User2D3nt1f13r" -User "vssa.User2D3nt1f13r" -Group "vssgp.Group2D3nt1f13r" -Allow "Read" -ProjectName "WebAppProject"
```
This example grants read permission to the work item area with ID 202 and path "Features\Registration" for a user with the descriptor "vssa.User2D3nt1f13r" and a group with the descriptor "vssgp.Group2D3nt1f13r" in the "WebAppProject".

### Example 3

```powershell
Add-VSTeamWorkItemAreaPermission -AreaID 203 -AreaPath "Features\Payments" -Descriptor "vssgp.User3D3nt1f13r" -User "vssa.User3D3nt1f13r" -Group "vssgp.Group3D3nt1f13r" -Allow "Read,Write,Delete" -ProjectName "WebAppProject" -OverwriteMask
```
In this command, permissions for the work item area with ID 203 and path "Features\Payments" are set for a user with the descriptor "vssa.User3D3nt1f13r" and a group with the descriptor "vssgp.Group3D3nt1f13r" in the "WebAppProject". The permissions are read, write, and delete. The `-OverwriteMask` switch indicates that these permissions will overwrite any existing permissions.

### Example 4

```powershell
$permissions = @{
    AreaID = 204
    AreaPath = "Features\Reporting"
    Descriptor = "vssgp.User4D3nt1f13r"
    User = "vssa.User4D3nt1f13r"
    Group = "vssgp.Group4D3nt1f13r"
    Allow = "Read"
    ProjectName = "WebAppProject"
}
Add-VSTeamWorkItemAreaPermission @permissions
```
This example uses a hashtable to define the permissions and then splats those values to the `Add-VSTeamWorkItemAreaPermission` command. The command grants read permission to the work item area with ID 204 and path "Features\Reporting" for a user with the descriptor "vssa.User4D3nt1f13r" and a group with the descriptor "vssgp.Group4D3nt1f13r" in the "WebAppProject".

### Example 5

```powershell
Add-VSTeamWorkItemAreaPermission -AreaID 205 -AreaPath "Features\Analytics" -Descriptor "vssgp.User5D3nt1f13r" -User "vssa.User5D3nt1f13r" -Group "vssgp.Group5D3nt1f13r" -Allow "Read,Write" -Deny "Delete" -ProjectName "WebAppProject" -Confirm
```
This command prompts for confirmation before adding read and write permissions and denying delete permission to the work item area with ID 205 and path "Features\Analytics" for a user with the descriptor "vssa.User5D3nt1f13r" and a group with the descriptor "vssgp.Group5D3nt1f13r" in the "WebAppProject".

## PARAMETERS

### AreaID

Area ID of the work item area for which the permissions are to be set.

```yaml
Type: Int32
Required: True
```

### AreaPath

Area path of the work item area for which the permissions are to be set.

```yaml
Type: String
Required: True
```

### Descriptor

Descriptor of the user or group to add permissions for.

```yaml
Type: String
Required: True
```

### User

User descriptor to add permissions for.

```yaml
Type: VSTeamUser
Required: True
```

### Group

Group descriptor to add permissions for.

```yaml
Type: VSTeamGroup
Required: True
```

### Allow

Allow permissions to add.

```yaml
Type: VSTeamWorkItemAreaPermissions
Required: True
```

### Deny

Deny permissions to add.

```yaml
Type: VSTeamWorkItemAreaPermissions
Required: True
```

### OverwriteMask

Switch to overwrite the mask values rather than merge them.

```yaml
Type: Switch
Required: False
```

<!-- #include "./params/projectName.md" -->

## INPUTS

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
