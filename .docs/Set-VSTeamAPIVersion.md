<!-- #include "./common/header.md" -->

# Set-VSTeamAPIVersion

## SYNOPSIS

<!-- #include "./synopsis/Set-VSTeamAPIVersion.md" -->

## SYNTAX

## DESCRIPTION

Set-VSTeamAPIVersion sets the versions of APIs used.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Set-VSTeamAPIVersion VSTS
```

This command sets the API versions to support VSTS.

## PARAMETERS

### -Version

Specifies the version to use.

Valid values: 'TFS2017', 'TFS2018', 'VSTS'

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Required: True
Position: 1
Default value: TFS2017
Accept pipeline input: False
Accept wildcard characters: False
```

<!-- #include "./params/force.md" -->

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS