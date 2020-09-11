<!-- #include "./common/header.md" -->

# Update-VSTeamBuild

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamBuild.md" -->

## SYNTAX

## DESCRIPTION

Allows you to set the keep forever flag and build number.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-VSTeamBuild | Update-VSTeamBuild -KeepForever $false
```

Sets the keep forever property of every build to false.

## PARAMETERS

<!-- #include "./params/projectName.md" -->

### -BuildNumber

The value you want to set as the build number.

```yaml
Type: String
Accept pipeline input: true (ByPropertyName, ByValue)
```

<!-- #include "./params/BuildId.md" -->

### -KeepForever

$True or $False to set the keep forever property of the build.

```yaml
Type: Boolean
Accept pipeline input: true (ByPropertyName, ByValue)
```

<!-- #include "./params/confirm.md" -->

<!-- #include "./params/force.md" -->

<!-- #include "./params/whatIf.md" -->

## INPUTS

## OUTPUTS

### Team.Build

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
