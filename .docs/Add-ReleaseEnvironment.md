#include "./common/header.md"

# Add-ReleaseEnvironment

## SYNOPSIS
Starts the deployment of an environment in an existing release.

## SYNTAX

```
Add-ReleaseEnvironment [-ProjectName] <String> [-Force] [-ReleaseId <String>] [-EnvironmentId <String>]
 [-EnvironmentStatus <String>]
```

## DESCRIPTION
Add-ReleaseEnvironment will start the deployment of an environment
within an existing release.

You must call Add-TeamAccount before calling this function.

## EXAMPLES

## PARAMETERS

#include "./params/projectName.md"

### -Force
Forces the command without confirmation

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReleaseId
Specifies the Id of an existing Release in which you want to deploy
to a particular environment.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnvironmentId
Specifies the Id of the Environment you wish to deploy to.
The Environment Ids are unique for each environment and in each release.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnvironmentStatus
Specifies the status in which to set the environment.
The deployment of an environment is triggered by changing the status of the environment.

The currently supported status change is from 'notStarted' to 'inProgress'

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

## NOTES
This function has a Dynamic Parameter for ProjectName that specifies the
project for which this function gets release s.

You can tab complete from a list of avaiable projects.

You can use Set-DefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS

