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

### Name

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: Named
Required: True
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Add-VSTeamProject](Add-VSTeamProject.md)
