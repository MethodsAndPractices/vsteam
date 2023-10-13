```markdown
<!-- #include "./common/header.md" -->

# Get-VSTeamBanner

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamBanner.md" -->

## SYNTAX

```powershell
Get-VSTeamBanner [-Id] <String> [<CommonParameters>]
```

## DESCRIPTION

<!-- #include "./description/Get-VSTeamBanner.md" -->

## EXAMPLES

### Example 1: Get a banner by ID

```powershell
Get-VSTeamBanner -Id '9547ed55-66e1-403d-95aa-9e628726861c'
```

## PARAMETERS

### Id

The ID of the banner to retrieve.

```yaml
Type: String
Required: True
```

## INPUTS

## OUTPUTS

### System.Object

The banner object returned from Azure DevOps.

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS