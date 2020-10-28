<!-- #include "./common/header.md" -->

# Get-VSTeamField

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamField.md -->

## SYNTAX

## DESCRIPTION
Every WorkItem has multiple data-fields. The definition of a Workitem type includes that type's fields, which are selected from a set of Fields shared across all process templates in the organization. This command returns those Fields, showing their name and other properties.

## EXAMPLES

### Example 1
```powershell
Get-VSTeamField
```

Returns a complete list of fields defined for the organization.

### Example 2
```powershell
Get-VSTeamField -Name priority

Name     Reference Name                 Usage    Type    IsPicklist Read Only Description
----     --------------                 -----    ----    ---------- --------- -----------
Priority Microsoft.VSTS.Common.Priority workItem integer False      False     Business importance. 1=must fix; 4=unimportant.
```

Returns a single matching field. Note the commands which work with fields will transform short names without wildcards, like 'priority', to a matching reference name (Microsoft.VSTS.Common.Priority in this case), but this is not a wildcard search. (See the next example for wildcards.)

### Example 3
```powershell
Get-VSTeamField *priority

Name             Reference Name                        Usage    Type    IsPicklist Read Only Description
----             --------------                        -----    ----    ---------- --------- -----------
Backlog Priority Microsoft.VSTS.Common.BacklogPriority workItem double  False      False
Priority         Microsoft.VSTS.Common.Priority        workItem integer False      False     Business importance. 1=must fix; 4=unimportant.
```

Returns all fields where either the name or the ReferenceName end with "priority". 
 
### Example 4
```powershell
Get-VSTeamField  priority,Backlog*

Name             Reference Name                        Usage    Type    IsPicklist Read Only Description
----             --------------                        -----    ----    ---------- --------- -----------
Priority         Microsoft.VSTS.Common.Priority        workItem integer False      False     Business importance. 1=must fix; 4=unimportant.
Backlog Priority Microsoft.VSTS.Common.BacklogPriority workItem double  False      False
```
This time two search terms are used, one transforms to the priority field, and the other is a wildcard search for anything starting with backlog, which matches on the Name "Backlog Priority". 

## PARAMETERS

### -ReferenceName
The fully-qualified or partial ReferenceName. Note that display names like "Target Date" which contain a space may have a reference name in the form "Microsoft.VSTS.Scheduling.TargetDate", and the resolution of the partial name looks for the section after the final "." character, which is "TargetDate" with no space, and therefore does not match the display name.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: true
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
[Get-VsteamWorkItemField](Get-VsteamWorkItemField.md)

[Add-VSTeamField](Add-VSTeamField.md)
