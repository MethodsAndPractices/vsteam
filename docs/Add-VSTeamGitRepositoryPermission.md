


# Add-VSTeamGitRepositoryPermission

## SYNOPSIS

Add permissions to a git repository, all repositories in a project, or a specific branch

## SYNTAX

## DESCRIPTION

Add permissions to a git repository, all repositories in a project, or a specific branch

## EXAMPLES

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

### -RepositoryId

```yaml
Type: String
Required: True
```

### -RepositoryName

```yaml
Type: String
Required: True
```

### -BranchName

```yaml
Type: String
Required: True
```

### -Descriptor

```yaml
Type: String
Required: True
```

### -User

```yaml
Type: VSTeamUser
Required: True
```

### -Group

```yaml
Type: VSTeamGroup
Required: True
```

### -Allow

```yaml
Type: VSTeamGitRepositoryPermissions
Required: True
```

### -Deny

```yaml
Type: VSTeamGitRepositoryPermissions
Required: True
```

## INPUTS

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

