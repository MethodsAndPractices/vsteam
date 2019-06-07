


# Get-VSTeamBuildLog

## SYNOPSIS

Displays the logs for the build.

## SYNTAX

## DESCRIPTION

Displays the logs for the build.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamBuild -Top 1 | Get-VSTeamBuildLog
```

This command displays the logs of the first build.

The pipeline operator (|) passes the build id to the Get-VSTeamBuildLog cmdlet, which
displays the logs.

## PARAMETERS

### -ProjectName

Specifies the team project for which this function operates.

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so
you do not have to pass the ProjectName with each call.

```yaml
Type: String
Position: 0
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -Id

Specifies one or more builds by ID.

To specify multiple IDs, use commas to separate the IDs.

To find the ID of a build, type Get-VSTeamBuild.

```yaml
Type: Int32[]
Aliases: BuildID
Accept pipeline input: true (ByPropertyName, ByValue)
```

### -Index

Each task stores its logs in an array. If you know the index of a specific task you can return just its logs. If you do not provide a value all the logs are displayed.

```yaml
Type: Int32
```

## INPUTS

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

