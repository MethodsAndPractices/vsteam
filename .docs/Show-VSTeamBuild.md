<!-- #include "./common/header.md" -->

# Show-VSTeamBuild

## SYNOPSIS

<!-- #include "./synopsis/Show-VSTeamBuild.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Show-VSTeamBuild.md" -->

## EXAMPLES

### Example 1

```powershell
Show-VSTeamBuild -ProjectName Demo -Id 3
```

This command will open a web browser with the summary of build 3.

## PARAMETERS

### Id

Specifies build by ID.

```yaml
Type: Int32
Position: 0
Aliases: BuildID
Required: True
Accept pipeline input: true (ByPropertyName)
```

### ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: 1
Required: True
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

## OUTPUTS

### vsteam_lib.Build

## NOTES

You can pipe the build ID to this function.

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamBuild](Add-VSTeamBuild.md)

[Remove-VSTeamBuild](Remove-VSTeamBuild.md)
