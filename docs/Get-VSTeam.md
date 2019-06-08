


# Get-VSTeam

## SYNOPSIS

Returns a team.

## SYNTAX

## DESCRIPTION

Returns a team.

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
Parameter Sets: List
```

### -TeamId

The id of the team to retrieve.

```yaml
Type: String[]
Parameter Sets: ByID
```

### -Top

Specifies the maximum number to return.

```yaml
Type: Int32
Parameter Sets: List
```

### -Name

The name of the team to retrieve.

```yaml
Type: String[]
Parameter Sets: ByName
```

## INPUTS

## OUTPUTS

### Team.Team

## NOTES

## RELATED LINKS

