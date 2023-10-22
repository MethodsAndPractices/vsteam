<!-- #include "./common/header.md" -->

# Add-VSTeamProjectPermission

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamProjectPermission.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamProjectPermission.md" -->

## EXAMPLES

### Example 1

```powershell
$user = Get-VSTeamUser -Id "john.doe@example.com"
$group = Get-VSTeamGroup -ProjectName "WebAppProject" -GroupName "Contributors"
Add-VSTeamProjectPermission -Descriptor $user.Descriptor -User $user -Group $group -Allow "CreateWorkItems" -Deny "DeleteRepository" -ProjectName "WebAppProject"
```

This command grants the user "john.doe@example.com" the permission to "CreateWorkItems" and denies the permission to "DeleteRepository" within the "WebAppProject" project, specifically assigning these permissions to the "Contributors" group.

### Example 2

```powershell
$group = Get-VSTeamGroup -ProjectName "BackendServices" -GroupName "Readers"
Add-VSTeamProjectPermission -Descriptor $group.Descriptor -Group $group -Allow "ReadWorkItems" -Deny "EditCode" -ProjectName "BackendServices"
```

Here, the "Readers" group in the "BackendServices" project is given the permission to "ReadWorkItems" but is denied the permission to "EditCode".

### Example 3

```powershell
$user = Get-VSTeamUser -Id "alice.smith@example.org"
$group = Get-VSTeamGroup -ProjectName "DataAnalytics" -GroupName "DataScientists"
Add-VSTeamProjectPermission -Descriptor $user.Descriptor -User $user -Group $group -Allow "RunQueries" -Deny "DeleteQueries" -ProjectName "DataAnalytics"
```

In this example, the user "alice.smith@example.org" is granted the permission to "RunQueries" and is denied the permission to "DeleteQueries" within the "DataAnalytics" project. These permissions are associated with the "DataScientists" group.

### Example 4

```powershell
$group = Get-VSTeamGroup -ProjectName "MobileApp" -GroupName "Developers"
Add-VSTeamProjectPermission -Descriptor $group.Descriptor -Group $group -Allow "CommitChanges" -Deny "DeleteBranch" -ProjectName "MobileApp"
```

The "Developers" group in the "MobileApp" project is given the permission to "CommitChanges" but is denied the permission to "DeleteBranch".

### Example 5

```powershell
$user = Get-VSTeamUser -Id "robert.jones@example.net"
$group = Get-VSTeamGroup -ProjectName "FrontendUI" -GroupName "Designers"
Add-VSTeamProjectPermission -Descriptor $user.Descriptor -User $user -Group $group -Allow "EditDesigns" -Deny "DeleteDesigns" -ProjectName "FrontendUI"
```

This command allows the user "robert.jones@example.net" to "EditDesigns" and denies the permission to "DeleteDesigns" within the "FrontendUI" project. These permissions are linked to the "Designers" group.

## PARAMETERS

### Descriptor

```yaml
Type: String
Required: True
```

### User

```yaml
Type: VSTeamUser
Required: True
```

### Group

```yaml
Type: VSTeamGroup
Required: True
```

### Allow

```yaml
Type: VSTeamProjectPermissions
Required: True
```

### Deny

```yaml
Type: VSTeamProjectPermissions
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
