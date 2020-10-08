<!-- #include "./common/header.md" -->

# Add-VSTeamProcess

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamProcess.md" -->

## SYNTAX

## DESCRIPTION

Add-VSTeamProcess will add a new Process template to your organization. Processes define the available WorkItem Types and the behaviours (backlog levels) for projects. Existing projects can be switched to a new process, and any enabled process can be used for creating new projects.

## EXAMPLES

### Example 1

```powershell
Add-VSTeamProcess -ParentProcess Basic -ProcessName "Basic J" -Description "New Basic Process"

Name    Enabled Default Description
----    ------- ------- -----------
Basic J True    False  New Basic Process
```

Creates a new process derived from the built-in process named "Basic". 

## PARAMETERS

<!-- #include "./params/confirm.md" -->

### -Description

The Description of the new process.

```yaml
Type: String
Required: False
```

<!-- #include "./params/force.md" -->

### -ParentProcess

New processes must be base on an existing process. This can be one of the built in processes names or the namea user defined process. The names should tab-complete.  

```yaml
Type: String
Required: True
```
### -ProcessName

The display-name for the new process. 

```yaml
Type: String
Aliases: Name
Required: True
```

### -ReferenceName

If not specified the a system-generated name will be assigned using the new process's GUID.

```yaml
Type: String
Required: False
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS

<!-- #include "./common/related.md" -->

[Set-VSTeamWorkItemType](Set-VSTeamWorkItemType.md)
