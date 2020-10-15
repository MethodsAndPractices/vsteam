<!-- #include "./common/header.md" -->

# Get-VSTeamField

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamField.md -->

## SYNTAX

## DESCRIPTION
Every WorkItem has multiple data-fields. The definition of a Workitem type includes that type's Fields, which are selected from a set of Fields shared across all Process Templates in the Organization. This command returns those Fields, showing their name and other properties.

## EXAMPLES

### Example 1
```powershell
Get-VSTeamField
```

Returns a complete list of Fields defined for the Organization.

### Example 1
```powershell
Get-VSTeamField -Name tags
```

Returns the System.Tags Field. Note the commands which work with Fields will resolve short names like Tags, to their reference names (System.Tags in this case) but do not support wildcards (System.Ta* will result in an error).

## PARAMETERS

### -ReferenceName
The fully-qualified or partial reference name. Note that display names like "Target Date" which contain a space may have a reference name in the form "Microsoft.VSTS.Scheduling.TargetDate" the resolution of the partial name looks for the section after the final "." character, which is "TargetDate" with no space, and therefore does not match the display name.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
[Get-VsteamWorkItemField](Get-VsteamWorkItemField.md)

[Add-VSTeamField](Add-VSTeamField.md)
