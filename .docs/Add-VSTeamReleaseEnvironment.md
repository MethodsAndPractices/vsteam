#include "./common/header.md"

# Add-VSTeamReleaseEnvironment

## SYNOPSIS
#include "./synopsis/Add-VSTeamReleaseEnvironment.md"

## SYNTAX

```
Add-VSTeamReleaseEnvironment [-ProjectName] <String> [-Force] [-ReleaseId <String>] [-EnvironmentId <String>]
 [-EnvironmentStatus <String>]
```

## DESCRIPTION
Add-VSTeamReleaseEnvironment will start the deployment of an environment
within an existing release.

You must call Add-VSTeamAccount before calling this function.

## EXAMPLES

## PARAMETERS

#include "./params/projectName.md"

#include "./params/force.md"

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

You can tab complete from a list of available projects.

You can use Set-VSTeamDefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS

