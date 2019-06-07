


# Add-VSTeamWorkItemAreaPermission

## SYNOPSIS

Add Permissions to a Work Item Area

## SYNTAX

## DESCRIPTION

Add Permissions to a Work Item Area

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

### -AreaID

```yaml
Type: Int32
Required: True
```

### -AreaPath

```yaml
Type: String
Required: True
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
Type: VSTeamWorkItemAreaPermissions
Required: True
```

### -Deny

```yaml
Type: VSTeamWorkItemAreaPermissions
Required: True
```

## INPUTS

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

