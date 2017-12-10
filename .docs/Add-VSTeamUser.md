#include "./common/header.md"

# Add-VSTeamUser

## SYNOPSIS
#include "./synopsis/Add-VSTeamUser.md"

## SYNTAX

```
Add-VSTeamUser [-Email] <String>
```

## DESCRIPTION
#include "./synopsis/Add-VSTeamUser.md"

## EXAMPLES

## PARAMETERS

#include "./params/projectName.md"

### -License
Type of Account License. The acceptable values for this parameter are:

- Advanced
- EarlyAdopter
- Express
- None
- Professional
- StakeHolder

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: EarlyAdopter
Accept pipeline input: False
Accept wildcard characters: False
```

### -Group
The acceptable values for this parameter are:

- Custom
- ProjectAdministrator
- ProjectContributor
- ProjectReader
- ProjectStakeholder

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: ProjectContributor
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS