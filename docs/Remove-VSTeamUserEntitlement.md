


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

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Aliases: cf
```

### -Force

Forces the command without confirmation

```yaml
Type: SwitchParameter
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

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Aliases: wi
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

