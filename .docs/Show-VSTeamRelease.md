<!-- #include "./common/header.md" -->

# Show-VSTeamRelease

## SYNOPSIS

<!-- #include "./synopsis/Show-VSTeamRelease.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Show-VSTeamRelease.md" -->

## EXAMPLES

### Example 1

```powershell
Show-VSTeamRelease -ProjectName Demo -Id 3
```

This command will open a web browser with the summary of release 3.

## PARAMETERS

### Id

Specifies release by ID.

```yaml
Type: Int32
Parameter Sets: ByID
Aliases: ReleaseID
Required: True
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

## NOTES

You can pipe the release ID to this function.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamRelease](Add-VSTeamRelease.md)

[Remove-VSTeamRelease](Remove-VSTeamRelease.md)
