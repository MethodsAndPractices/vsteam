<!-- #include "./common/header.md" -->

# Add-VSTeamProcess

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamProcess.md" -->

## SYNTAX

## DESCRIPTION

Add-VSTeamProcess will add a new Process template to your organization. Processes define the available WorkItem Types and the Behaviors (backlog levels) for Projects. Existing Projects can be switched to a new Process, and any enabled Process can be used for creating new Projects.

## EXAMPLES

### Example 1

```powershell
Add-VSTeamProcess -ParentProcess Basic -ProcessName "Basic J" -Description "New Basic Process"

Name    Enabled Default Description
----    ------- ------- -----------
Basic J True    False  New Basic Process
```

Creates a new Process template derived from the built-in Process named "Basic".

## PARAMETERS

<!-- #include "./params/confirm.md" -->

### -Description

The description of the new Process.

```yaml
Type: String
Required: False
```

<!-- #include "./params/force.md" -->

### -ParentProcess

New Processes must be based on an existing {rocess. This can be one of the built in Processes names or the name of a user defined process. The names should tab-complete.

```yaml
Type: String
Required: True
```
### -ProcessName

The display-name for the new Process.

```yaml
Type: String
Aliases: Name
Required: True
```

### -ReferenceName

If not specified the a system-generated name will be assigned using the new Process's GUID.

```yaml
Type: String
Required: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Set-VSTeamProcess](Set-VSTeamProcess.md)

[Get-VSTeamProcess](Get-VSTeamProcess.md)
