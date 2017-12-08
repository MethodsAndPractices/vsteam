#include "./common/header.md"

# Remove-VSTeamUser

## SYNOPSIS
#include "./synopsis/Remove-VSTeamUser.md"

## SYNTAX

### ByID
```
Remove-VSTeamUser [-UserId] <String> [-Force] [-WhatIf] [-Confirm]
```

### ByEmail
```
Remove-VSTeamUser [-Email] <String> [-Force] [-WhatIf] [-Confirm]
```

## DESCRIPTION
#include "./synopsis/Remove-VSTeamUser.md"

## EXAMPLES

## PARAMETERS

#include "./params/confirm.md"

#include "./params/force.md"

### -UserId
The id of the user to remove.

```yaml
Type: String
Parameter Sets: ByID
Aliases: name

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Email
The email of the user to remove.

```yaml
Type: String
Parameter Sets: ByEmail
Aliases: name

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

#include "./params/whatIf.md"

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS