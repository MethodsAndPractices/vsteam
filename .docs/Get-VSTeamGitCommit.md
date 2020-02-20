<!-- #include "./common/header.md" -->

# Get-VSTeamGitCommit

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamGitCommit.md" -->

## SYNTAX

## DESCRIPTION

The Get-VSTeamGitCommit function gets the commits for a git repository.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamGitCommit -ProjectName demo -RepositoryId 118C262F-0D4C-4B76-BD9B-7DD8CA12F196
```

This command gets a list of all commits in the demo project for a specific repository.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -RepositoryId

The id or friendly name of the repository. To use the friendly name, projectId must also be specified.

```yaml
Type: Guid
Required: True
Accept pipeline input: true (ByPropertyName)
Parameter Sets: All, ItemVersion, CompareVersion, ItemPath, ByIds
```

### -FromDate

If provided, only include history entries created after this date (string)

```yaml
Type: DateTime
Parameter Sets: All, ItemVersion, CompareVersion, ItemPath
```

### -ToDate

If provided, only include history entries created before this date (string)

```yaml
Type: DateTime
Parameter Sets: All, ItemVersion, CompareVersion, ItemPath
```

### -ItemVersionVersionType

Version type (branch, tag, or commit). Determines how Id is interpreted. The acceptable values for this parameter are:

- branch
- commit
- tag

```yaml
Type: String
Parameter Sets: All, ItemVersion, CompareVersion, ItemPath
```

### -ItemVersionVersion

Version string identifier (name of tag/branch, SHA1 of commit)

```yaml
Type: String
Parameter Sets: All, ItemVersion, CompareVersion, ItemPath
```

### -ItemVersionVersionOptions

Version options - Specify additional modifiers to version (e.g Previous). The acceptable values for this parameter are:

- firstParent
- none
- previousChange

```yaml
Type: String
Parameter Sets: All, ItemVersion, CompareVersion, ItemPath
```

### -CompareVersionVersionType

Version type (branch, tag, or commit). Determines how Id is interpreted. The acceptable values for this parameter are:

- branch
- commit
- tag

```yaml
Type: String
Parameter Sets: All, ItemVersion, CompareVersion, ItemPath
```

### -CompareVersionVersion

Version string identifier (name of tag/branch, SHA1 of commit). The acceptable values for this parameter are:

- firstParent
- none
- previousChange

```yaml
Type: String
Parameter Sets: All, ItemVersion, CompareVersion, ItemPath
```

### -CompareVersionVersionOptions

Version options - Specify additional modifiers to version (e.g Previous)

```yaml
Type: String
Parameter Sets: All, ItemVersion, CompareVersion, ItemPath
```

### -FromCommitId

If provided, a lower bound for filtering commits alphabetically

```yaml
Type: String
Parameter Sets: All, ItemVersion, CompareVersion, ItemPath
```

### -ToCommitId

If provided, an upper bound for filtering commits alphabetically

```yaml
Type: String
Parameter Sets: All, ItemVersion, CompareVersion, ItemPath
```

### -Author

Alias or display name of the author

```yaml
Type: String
Parameter Sets: All, ItemVersion, CompareVersion, ItemPath
```

### -Ids

If provided, specifies the exact commit ids of the commits to fetch. May not be combined with other parameters.

```yaml
Type: String
Parameter Sets: ByIds
```

### -ItemPath

Path of item to search under

```yaml
Type: String
Parameter Sets: All, ItemPath
```

### -ExcludeDeletes

Only applies when an itemPath is specified. This determines whether to exclude delete entries of the specified path.

```yaml
Type: Switch
Parameter Sets: All, ItemPath
```

### -Top

Maximum number of entries to retrieve

```yaml
Type: Int32
Parameter Sets: All, ItemVersion, CompareVersion, ItemPath
```

### -Skip

Number of entries to skip

```yaml
Type: Int32
Parameter Sets: All, ItemVersion, CompareVersion, ItemPath
```

### -HistoryMode

What Git history mode should be used. This only applies to the search criteria when Ids = null and an itemPath is specified. The acceptable values for this parameter are:

- firstParent
- fullHistory
- fullHistorySimplifyMerges
- simplifiedHistory

```yaml
Type: String
Parameter Sets: ItemPath
```

### -User

Alias or display name of the committer

```yaml
Type: String
Parameter Sets: All, ItemVersion, CompareVersion, ItemPath
```

## INPUTS

## OUTPUTS

## NOTES

This function has a Dynamic Parameter for ProjectName that specifies the project for which this function gets commits.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have to pass the ProjectName with each call.

You can pipe a repository ID to this function.

## RELATED LINKS
