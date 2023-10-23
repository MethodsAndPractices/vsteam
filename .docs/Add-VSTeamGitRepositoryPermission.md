<!-- #include "./common/header.md" -->

# Add-VSTeamGitRepositoryPermission

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamGitRepositoryPermission.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamGitRepositoryPermission.md" -->

## EXAMPLES

### Example 1

```powershell
$descriptorUser = "vssgp.Uy0xLTktMTU1MTM3NDI0NS0xMzM4Mzc4Njg5LTE5MzM0NTM5NjYtMzQ3NzU4NjI4OS0yNTA2ODc2NTA5LTAuMA"
$descriptorGroup = "vssgp.Uy0xLTktMTU1MTM3NDI0NS0xMzM4Mzc4Njg5LTE5MzM0NTM5NjYtMzQ3NzU4NjI4OS0yNTA2ODc2NTA5LTAuMQ"
Add-VSTeamGitRepositoryPermission -RepositoryId "1a2b3c4d" -RepositoryName "MyRepo" -BranchName "main" -Descriptor $descriptorUser -User $descriptorUser -Group $descriptorGroup -Allow "Read,Contribute" -Deny "Delete" -ProjectName "WebAppProject"
```

This command adds read and contribute permissions to the "main" branch of the "MyRepo" repository for the specified user and group while denying the delete permission. The user and group are specified using their respective descriptors.

### Example 2

```powershell
$descriptorUser = "vssgp.Uy0xLTktMTU1MTM3NDI0NS0xMzM4Mzc4Njg5LTE5MzM0NTM5NjYtMzQ3NzU4NjI4OS0yNTA2ODc2NTA5LTAuMA"
Add-VSTeamGitRepositoryPermission -RepositoryId "2b3c4d5e" -RepositoryName "AnotherRepo" -BranchName "dev" -Descriptor $descriptorUser -User $descriptorUser -Allow "Read" -ProjectName "BackendServices"
```

Here, read permission is granted to the "dev" branch of the "AnotherRepo" repository for the specified user using the user descriptor.

### Example 3

```powershell
$descriptorGroup = "vssgp.Uy0xLTktMTU1MTM3NDI0NS0xMzM4Mzc4Njg5LTE5MzM0NTM5NjYtMzQ3NzU4NjI4OS0yNTA2ODc2NTA5LTAuMQ"
Add-VSTeamGitRepositoryPermission -RepositoryId "3c4d5e6f" -RepositoryName "ThirdRepo" -BranchName "feature" -Descriptor $descriptorGroup -Group $descriptorGroup -Allow "Read,Contribute,Manage" -ProjectName "DataAnalytics"
```

In this example, read, contribute, and manage permissions are granted to the "feature" branch of the "ThirdRepo" repository for the specified group using the group descriptor.

### Example 4

```powershell
$descriptorUser = "vssgp.Uy0xLTktMTU1MTM3NDI0NS0xMzM4Mzc4Njg5LTE5MzM0NTM5NjYtMzQ3NzU4NjI4OS0yNTA2ODc2NTA5LTAuMA"
Add-VSTeamGitRepositoryPermission -RepositoryId "4d5e6f7g" -RepositoryName "FourthRepo" -BranchName "hotfix" -Descriptor $descriptorUser -User $descriptorUser -Allow "Read" -Deny "Contribute,Delete" -ProjectName "MobileApp"
```

This command grants read permission and denies contribute and delete permissions to the "hotfix" branch of the "FourthRepo" repository for the specified user using the user descriptor.

### Example 5

```powershell
$descriptorGroup = "vssgp.Uy0xLTktMTU1MTM3NDI0NS0xMzM4Mzc4Njg5LTE5MzM0NTM5NjYtMzQ3NzU4NjI4OS0yNTA2ODc2NTA5LTAuMQ"
Add-VSTeamGitRepositoryPermission -RepositoryId "5e6f7g8h" -RepositoryName "FifthRepo" -BranchName "release" -Descriptor $descriptorGroup -Group $descriptorGroup -Allow "Read,Contribute" -ProjectName "FrontendUI"
```

This example grants read and contribute permissions to the "release" branch of the "FifthRepo" repository for the specified group using the group descriptor.

## PARAMETERS

### RepositoryId

ID of the repository for which the permissions are to be set.

```yaml
Type: String
Required: True
```

### RepositoryName

Name of the repository for which the permissions are to be set.

```yaml
Type: String
Required: True
```

### BranchName

Name of the branch for which the permissions are to be set.

```yaml
Type: String
Required: True
```

### Descriptor

Descriptor of the user or group for which the permissions are to be set.

```yaml
Type: String
Required: True
```

### User

User descriptor for which the permissions are to be set.

```yaml
Type: VSTeamUser
Required: True
```

### Group

Group descriptor for which the permissions are to be set.

```yaml
Type: VSTeamGroup
Required: True
```

### Allow

Allow permissions to be set.

```yaml
Type: VSTeamGitRepositoryPermissions
Required: True
```

### Deny

Deny permissions to be set.

```yaml
Type: VSTeamGitRepositoryPermissions
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
