<!-- #include "./common/header.md" -->

# Remove-VSTeamProject

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamProject.md" -->

## SYNTAX

## DESCRIPTION

This will permanently delete your Team Project from your Team Services account.

This function takes a DynamicParam for ProjectName that can be read from the Pipeline by Property Name

## EXAMPLES

### Example 1

```powershell
Remove-VSTeamProject 'MyProject'
```

You will be prompted for confirmation and the project will be deleted.

### Example 2

```powershell
Remove-VSTeamProject 'MyProject' -Force
```

You will NOT be prompted for confirmation and the project will be deleted.

### Example 3

```powershell
Get-VSTeamProject | Remove-VSTeamProject -Force
```

This will remove all projects

## PARAMETERS

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamProject](Add-VSTeamProject.md)
