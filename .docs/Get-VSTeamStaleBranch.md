<!-- #include "./common/header.md" -->

# Get-VSTeamStaleBranch

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamStaleBranch.md" -->

## SYNTAX

## DESCRIPTION

Retrieve Stale Branches

You must call Set-VSTeamAccount before calling this function.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamStaleBranch
```

This will return all branches that have not been committed to within 90 days (default value)

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamStaleBranch -top 5 | Format-Wide
```

This will return the top five Process Templates only showing their name

## PARAMETERS

<!-- #include "./params/ProcessName.md" -->

### -RepositoryId

Specifies the Repository Id to process

```yaml
Type: Guid
Parameter Sets: ByRepositoryId
```

### -MaximumAgeDays

The maximum number of days a branch has not been committed to rending it "stale"

```yaml
Type: Int32
Default value: 90
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
