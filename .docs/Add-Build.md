#include "./common/header.md"

# Add-Build

## SYNOPSIS
#include "./synopsis/Add-Build.md"

## SYNTAX

```
Add-Build [-ProjectName] <String> [-BuildDefinition <String>] [-QueueName <String>]
```

## DESCRIPTION
Add-Build will queue a new build.
You can override the queue in the build defintion by using the QueueName
parameter.

To have the BuildDefinition and QueueNames tab complete you must set a default
project by calling Set-DefaultProject before you call Add-Build.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Set-DefaultProject Demo
PS C:\> Add-Build -BuildDefinition Demo-CI

Build Definition Build Number  Status     Result
---------------- ------------  ------     ------
Demo-CI           Demo-CI-45   notStarted
```

This example sets the default project so you can tab complete the BuildDefinition parameter.

## PARAMETERS

#include "./params/projectName.md"

### -BuildDefinition
The name of the build defintion to use to queue to build.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -QueueName
The name of the queue to use for this build.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

### System.String
Build Defintion Name

### System.String
Queue Name

## OUTPUTS

## NOTES
BuildDefinition and QueueName are dynamic parameters and use the default 
project value to query their validate set. 

If you do not set the default project by called Set-DefaultProject before
calling Add-Build you will have to type in the names.

## RELATED LINKS