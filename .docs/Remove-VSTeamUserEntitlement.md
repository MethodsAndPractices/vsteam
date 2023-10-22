<!-- #include "./common/header.md" -->

# Remove-VSTeamUserEntitlement

## SYNOPSIS

<!-- #include "./synopsis/Remove-VSTeamUserEntitlement.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Remove-VSTeamUserEntitlement.md" -->

## EXAMPLES

### Example 1
```powershell
Remove-VSTeamUserEntitlement -Id "12345678-abcd-1234-abcd-1234567890ab"
```

Removes the user entitlement with ID `12345678-abcd-1234-abcd-1234567890ab`.

### Example 2
```powershell
Remove-VSTeamUserEntitlement -Email "user1@example.com"
```

Removes the user entitlement for the user with the email "user1@example.com".

### Example 3
```powershell
Remove-VSTeamUserEntitlement -Id "12345678-abcd-1234-abcd-1234567890ab" -Force
```

Removes the user entitlement with ID `12345678-abcd-1234-abcd-1234567890ab` and forces the removal without any confirmation prompts.

## PARAMETERS

### Id

The id of the user to remove.

```yaml
Type: String
Parameter Sets: ByID
Aliases: UserId
Required: True
Accept pipeline input: true (ByPropertyName)
```

### Email

The email of the user to remove.

```yaml
Type: String
Parameter Sets: ByEmail
Aliases: name
Required: True
Accept pipeline input: true (ByPropertyName)
```

<!-- #include "./params/forcegroup.md" -->

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS
