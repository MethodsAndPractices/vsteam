<!-- #include "./common/header.md" -->

# Update-VSTeamRelease

## SYNOPSIS

<!-- #include "./synopsis/Update-VSTeamRelease.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Update-VSTeamRelease.md" -->

## EXAMPLES

### Example 1

```powershell
Set-VSTeamAccount -Account mydemos -Token $(System.AccessToken) -UseBearerToken
$r = Get-VSTeamRelease -ProjectName project -Id 76 -Raw
$r.variables.temp.value='temp'
Update-VSTeamRelease -ProjectName project -Id 76 -release $r
```

Changes the variable temp on the release. This can be done in one stage and read in another stage.

### Example 2

```powershell
Set-VSTeamAccount -Account mydemos -Token $(System.AccessToken) -UseBearerToken
$r = Get-VSTeamRelease -ProjectName project -Id 76 -Raw
$r.variables | Add-Member NoteProperty temp([PSCustomObject]@{value='test'})
Update-VSTeamRelease -ProjectName project -Id 76 -release $r
```

Adds a variable temp to the release with a value of test.

## PARAMETERS

### Id

The id of the release to update

```yaml
Type: Int32
Required: True
Accept pipeline input: true (ByPropertyName)
```

### Release

The updated release to save in AzD

```yaml
Type: PSCustomObject
Required: True
```

<!-- #include "./params/projectName.md" -->

<!-- #include "./params/forcegroup.md" -->

## INPUTS

## OUTPUTS

### vsteam_lib.Release

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
