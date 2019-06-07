


# Add-VSTeamProjectPermission

## SYNOPSIS

Add Permissions on Project Level

## SYNTAX

## DESCRIPTION

Add Permissions on Project Level

## EXAMPLES

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

### -Descriptor

```yaml
Type: String
Required: True
```

### -User

```yaml
Type: VSTeamUser
Required: True
```

### -Group

```yaml
Type: VSTeamGroup
Required: True
```

### -Allow

```yaml
Type: VSTeamProjectPermissions
Required: True
```

### -Deny

```yaml
Type: VSTeamProjectPermissions
Required: True
```

## INPUTS

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

