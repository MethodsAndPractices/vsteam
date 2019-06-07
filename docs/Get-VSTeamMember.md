


# Get-VSTeamMember

## SYNOPSIS

Returns a team member.

## SYNTAX

## DESCRIPTION

Returns a team member.

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

### -Skip

The number of items to skip.

```yaml
Type: Int32
```

### -TeamId

The id of the team to search.

```yaml
Type: String
Aliases: name
Required: True
Position: 2
Accept pipeline input: true (ByPropertyName)
```

### -Top

Specifies the maximum number to return.

```yaml
Type: Int32
```

## INPUTS

## OUTPUTS

### Team.Team

## NOTES

## RELATED LINKS

