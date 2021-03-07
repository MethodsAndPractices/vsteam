<!-- #include "./common/header.md" -->

# Show-VSTeamPackage

## SYNOPSIS

<!-- #include "./synopsis/Show-VSTeamPackage.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Show-VSTeamPackage.md" -->

## EXAMPLES

### Example 1: From pipeline

```powershell
Get-VSTeamPackage -feedName vsteam -Top 1 -Skip 2 | Show-VSTeamPackage
```

This command will open a web browser with this package showing.

### Example 2: By parameter

```powershell
$p = Get-VSTeamPackage -feedName vsteam -Top 1 -Skip 2
Show-VSTeamPackage $p
```

This command will open a web browser with this package showing.

## PARAMETERS

### Package

Package to show

```yaml
Type: vsteam_lib.Package
Required: True
Position: 0
Accept pipeline input: true (ByPropertyName)
```

## INPUTS

### vsteam_lib.Package

## OUTPUTS

### vsteam_lib.Package

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Add-VSTeamPackage](Add-VSTeamPackage.md)
