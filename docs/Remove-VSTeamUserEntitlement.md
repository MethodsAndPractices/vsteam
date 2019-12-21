


# Remove-VSTeamUserEntitlement

## SYNOPSIS

Delete a user from the account.

The delete operation includes unassigning Extensions and Licenses and removing the user from all project memberships. The user would continue to have access to the account if she is member of an AAD group, that is added directly to the account.

## SYNTAX

## DESCRIPTION

Delete a user from the account.

The delete operation includes unassigning Extensions and Licenses and removing the user from all project memberships. The user would continue to have access to the account if she is member of an AAD group, that is added directly to the account.

## EXAMPLES

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the function.

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
Aliases: cf
```

### -Force

Forces the function without confirmation

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
```

### -UserId

The id of the user to remove.

```yaml
Type: String
Parameter Sets: ByID
Aliases: name
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -Email

The email of the user to remove.

```yaml
Type: String
Parameter Sets: ByEmail
Aliases: name
Required: True
Accept pipeline input: true (ByPropertyName)
```

### -WhatIf

Shows what would happen if the function runs.
The function is not run.

```yaml
Type: SwitchParameter
Required: false
Position: Named
Accept pipeline input: false
Parameter Sets: (All)
Aliases: wi
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

