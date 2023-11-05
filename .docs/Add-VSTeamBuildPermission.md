<!-- #include "./common/header.md" -->

# Add-VSTeamBuildPermission

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamBuildPermission.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamBuildPermission.md" -->

## EXAMPLES

### Example 1

```powershell
  $project = Get-VSTeamProject -Name MyProject
  $user = Get-VSTeamUser -Descriptor "Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com"
  Add-VSTeamBuildPermission -Project $project -User $user -Allow DestroyBuilds, DeleteBuildDefinition, AdministerBuildPermissions -Deny StopBuilds, QueueBuilds, EditBuildDefinition
```

Adds the user 'test@testuser.com' with the given descriptor to the build pipelines on project level. Permits the user to destroy builds, delete build definitions and administer them. Also denies to stop or queue builds as well as editing build definitions.

### Example 2

```powershell
  $project = Get-VSTeamProject -Name MyProject
  $user = Get-VSTeamUser -Descriptor "Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com"
Add-VSTeamBuildPermission -Project $project -User $user
Warning: Permission masks for Allow and Deny do not inlude any permission. No Permission will change!
```

Tries to the user 'test@testuser.com' with the given descriptor to the build pipelines on project level. No permissions (allow and deny) are given, it is possible but a warning is thrown.

### Example 3

```powershell
  $project = Get-VSTeamProject -Name MyProject
  $user = Get-VSTeamUser -Descriptor "Microsoft.IdentityModel.Claims.ClaimsIdentity;788df857-dcd8-444d-885e-bff359bc1982\\test@testuser.com"
Add-VSTeamBuildPermission -Project $project -BuildID 5 -User $user -Allow DestroyBuilds -Deny StopBuilds
```

Allows the user 'test@testuser.com' to the build with ID 5 to destry builds and deny to stop builds.

## PARAMETERS

### ProjectID

ID of the project.

### BuildID

The build ID of the build pipeline to permit the identity object to.

```yaml
Type: String
Required: True
```

### Descriptor

The descriptor of the user or group to permit to

```yaml
Type: String
Required: True
```

### User

The user or service account to permit to. Service accounts are handled like normal users. The descriptor differs a little bit.

```yaml
Type: VSTeamUser
Required: True
```

### Group

The group to permit to

```yaml
Type: VSTeamGroup
Required: True
```

### Allow

Permissions that should be allowed. If no permissions are needed, then leave this parameter out.

```yaml
Type: VSTeamProjectPermissions
Required: True
```

### Deny

Permissions that should be denied. If no permissions are needed, then leave this parameter out.

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
