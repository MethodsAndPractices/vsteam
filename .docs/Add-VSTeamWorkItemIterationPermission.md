<!-- #include "./common/header.md" -->

# Add-VSTeamWorkItemIterationPermission

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamWorkItemIterationPermission.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamWorkItemIterationPermission.md" -->

## EXAMPLES

### Example 1

```powershell
Add-VSTeamWorkItemIterationPermission -IterationID 101 -IterationPath "Sprint 5" -Descriptor "vssgp.Uz3r1D3nt1f13r" -User "vssa.Uz3r1D3nt1f13rForUser" -Group "vssgp.Uz3r1D3nt1f13rForGroup" -Allow "Read,Write" -Deny "Delete" -ProjectName "MyProject"
```

This command adds read and write permissions to the iteration with ID 101 and path "Sprint 5" for a user with the descriptor "vssa.Uz3r1D3nt1f13rForUser" and a group with the descriptor "vssgp.Uz3r1D3nt1f13rForGroup" in the "MyProject". It denies the delete permission for the same.

### Example 2

```powershell
Add-VSTeamWorkItemIterationPermission -IterationID 102 -IterationPath "Sprint 6" -Descriptor "vssgp.An0th3r1D3nt1f13r" -User "vssa.An0th3r1D3nt1f13rForUser" -Group "vssgp.An0th3r1D3nt1f13rForGroup" -Allow "Read" -ProjectName "MyProject"
```

This example gives read permission to the iteration with ID 102 and path "Sprint 6" for a user with the descriptor "vssa.An0th3r1D3nt1f13rForUser" and a group with the descriptor "vssgp.An0th3r1D3nt1f13rForGroup" in the "MyProject".

### Example 3

```powershell
Add-VSTeamWorkItemIterationPermission -IterationID 103 -IterationPath "Sprint 7" -Descriptor "vssgp.Th1rd1D3nt1f13r" -User "vssa.Th1rd1D3nt1f13rForUser" -Group "vssgp.Th1rd1D3nt1f13rForGroup" -Allow "Read,Write,Delete" -ProjectName "MyProject" -OverwriteMask
```

In this command, permissions for the iteration with ID 103 and path "Sprint 7" are set for a user with the descriptor "vssa.Th1rd1D3nt1f13rForUser" and a group with the descriptor "vssgp.Th1rd1D3nt1f13rForGroup" in the "MyProject". The permissions are read, write, and delete. The `-OverwriteMask` switch indicates that these permissions will overwrite any existing permissions.

### Example 4

```powershell
$permissions = @{
    IterationID = 104
    IterationPath = "Sprint 8"
    Descriptor = "vssgp.F0urth1D3nt1f13r"
    User = "vssa.F0urth1D3nt1f13rForUser"
    Group = "vssgp.F0urth1D3nt1f13rForGroup"
    Allow = "Read"
    ProjectName = "MyProject"
}
Add-VSTeamWorkItemIterationPermission @permissions
```

This example uses a hashtable to define the permissions and then splats those values to the `Add-VSTeamWorkItemIterationPermission` command. The command gives read permission to the iteration with ID 104 and path "Sprint 8" for a user with the descriptor "vssa.F0urth1D3nt1f13rForUser" and a group with the descriptor "vssgp.F0urth1D3nt1f13rForGroup" in the "MyProject".

### Example 5

```powershell
Add-VSTeamWorkItemIterationPermission -IterationID 105 -IterationPath "Sprint 9" -Descriptor "vssgp.F1fth1D3nt1f13r" -User "vssa.F1fth1D3nt1f13rForUser" -Group "vssgp.F1fth1D3nt1f13rForGroup" -Allow "Read,Write" -Deny "Delete" -ProjectName "MyProject" -Confirm
```

This command prompts for confirmation before adding read and write permissions and denying delete permission to the iteration with ID 105 and path "Sprint 9" for a user with the descriptor "vssa.F1fth1D3nt1f13rForUser" and a group with the descriptor "vssgp.F1fth1D3nt1f13rForGroup" in the "MyProject".

## PARAMETERS

### IterationID

Iteration ID for which the permissions are to be set.

```yaml
Type: Int32
Required: True
```

### IterationPath

Iteration path for which the permissions are to be set.

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
Type: VSTeamWorkItemIterationPermissions
Required: True
```

### Deny

Deny permissions to add.

```yaml
Type: VSTeamWorkItemIterationPermissions
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
