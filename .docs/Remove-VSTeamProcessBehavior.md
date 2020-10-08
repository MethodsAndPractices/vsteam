<!-- #include "./common/header.md" -->

# Remove-VSTeamProcessBehavior

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamProcessBehavior.md" -->

## SYNTAX

## Description

<!-- #include "./synopsis/Remove-VSTeamProcessBehavior.md" -->

## EXAMPLES

### Example 1

```powershell
Set-VSTeamProcessBehavior -ProcessTemplate Scrum5 -Name "Change Requests" 
```
Removes a portfolio backlog from the scrum5 processs template (note that the only custom behaviors on custom templates can be removed). 

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet. Normally the command will prompt for confirmation and -Confirm is only needed if \$ConfirmPreference has been changed.

<!-- #include "./params/force.md" -->

### -Name

Current name of the behavior / backlog

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```



<!-- #include "./params/whatIf.md" -->

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->
[Add-VSTeamProcessBehavior](Add-VSTeamProcessBehavior.md)

[Get-VSTeamProcessBehavior](Get-VSTeamProcessBehavior.md)

[Set-VSTeamProcessBehavior](Set-VSTeamProcessBehavior.md)
