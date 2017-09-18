#include "./common/header.md"

# Get-BuildLog

## SYNOPSIS
#include "./synopsis/Get-BuildLog.md"

## SYNTAX

```
Get-BuildLog [-Id <Int32[]>] [-Index <Int32>] [-ProjectName] <String>
```

## DESCRIPTION
#include "./synopsis/Get-BuildLog.md"

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-Build -Top 1 | Get-BuildLog
```

This command displays the logs of the first build.

The pipeline operator (|) passes the build id to the Get-BuildLog cmdlet, which
displays the logs.

## PARAMETERS

#include "./params/BuildIds.md"

### -Index
Each task stores its logs in an array. If you know the index of a specific task
you can return just its logs. If you do not provide a value all the logs are
displayed.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#include "./params/projectName.md"

## INPUTS

### System.Int32[]
System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS