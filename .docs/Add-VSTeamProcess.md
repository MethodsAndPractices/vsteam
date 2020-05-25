<!-- #include "./common/header.md" -->

# Add-VSTeamProcess

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamProcess.md" -->

## SYNTAX

## DESCRIPTION

Add-VSTeamProcess will add a new process template to your organization. Processes define the available WorkItem types and the behaviours (backlog levels) for projects. Existing projects can be switched to a new process, and any enabled process can be used for creating new projects.

## EXAMPLES

### EXAMPLE Process Creation.

```PowerShell
PS C:\> Add-VSTeamProcess -ParentProcess Basic -ProcessName "Basic J" -Description "New Basic Process" -ReferenceName "Custom.BASICJ"

Name        : Basic J
ID          : b63c91af-84c0-4bce-855a-65342208698b
Description : New Basic Process
IsEnabled   : True
IsDefault   : False
```

## PARAMETERS

### -ProcessName

The display-name for the new process. 

```yaml
Type: String
Aliases: Name
Required: True
```

### -Description

The Description of the new process.

```yaml
Type: String
Required: False
```

### -ReferenceName

If not specified the a system-generated name will be assigned using the new process's GUID.

```yaml
Type: String
Required: False
```

### -ParentProcess

New processes must be base on an existing process. This can be one of the built in processes names or the namea user defined process. The names should tab-complete.  

```yaml
Type: String
Required: True
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
