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

```PowerShell
PS C:\> Remove-VSTeamProject 'MyProject'
```

You will be prompted for confirmation and the project will be deleted.

### Example 2

```PowerShell
PS C:\> Remove-VSTeamProject 'MyProject' -Force
```

You will NOT be prompted for confirmation and the project will be deleted.

### Example 3

```PowerShell
PS C:\> Get-VSTeamProject | Remove-VSTeamProject -Force
```

This will remove all projects

## PARAMETERS

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/force.md" -->

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Set-VSTeamAccount](Set-VSTeamAccount.md)

[Add-VSTeamProject](Add-VSTeamProject.md)
