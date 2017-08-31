---
external help file: Team-Help.xml
Module Name: 
online version: 
schema: 2.0.0
---

# Add-Build

## SYNOPSIS
Queues a new build.

## SYNTAX

```
Add-Build [-ProjectName] <String> [-BuildDefinition <String>] [-QueueName <String>]
```

## DESCRIPTION
Add-Build will queue a new build.
You can override the queue in the build defintion by using the QueueName parameter.

To have the BuildDefinition and QueueNames tab complete you must set a default project by calling Set-DefaultProject before you call Add-Build.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Set-DefaultProject Demo
PS C:\>Add-Build -BuildDefinition Demo-CI
```

This exmaple sets the default project so you can tab complete the BuildDefinition parameter.

## PARAMETERS

### -ProjectName
Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-DefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

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

### Team-Build
The team build just created.

Build Definition Build Number  Status     Result
---------------- ------------  ------     ------
Demo-CI           Demo-CI-45   notStarted

## NOTES
BuildDefinition and QueueName are dynamic parameters and use the default project value to query their validate set. 
If you do not set the default project by called Set-DefaultProject before calling Add-Build you will have to type in the names.

## RELATED LINKS

