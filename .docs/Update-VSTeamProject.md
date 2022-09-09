<!-- #include "./common/header.md" -->

# Update-VSTeamProject

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamProject.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeamProject.md" -->

## EXAMPLES

### Example 1

```powershell
Update-VSTeamProject -Name Demo -NewName aspDemo
```

This command changes the name of your project from Demo to aspDemo.

### Example 2: Make a project public

```powershell
Update-VSTeamProject -Name Demo -Visibility public
```

This command makes your project public.

## PARAMETERS

### NewName

The new name for the project.

```yaml
Type: String
```

### NewDescription

The new description for the project.

```yaml
Type: String
```

### Id

The id of the project to update.

```yaml
Type: String
Parameter Sets: (ByID)
Aliases: ProjectId
Accept pipeline input: true (ByPropertyName)
```

### Visibility

The visibility of the project.

```yaml
Type: String
Accepted values: private, public
```

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
