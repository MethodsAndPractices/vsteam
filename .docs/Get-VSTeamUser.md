<!-- #include "./common/header.md" -->

# Get-VSTeamUser

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamUser.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Get-VSTeamUser.md" -->

## EXAMPLES

## PARAMETERS

### -Skip

The number of items to skip.

```yaml
Type: Int32
Parameter Sets: List
Aliases:
Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserId

The id of the user to retrieve.

```yaml
Type: String[]
Parameter Sets: ByID
Aliases:
Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Top

Specifies the maximum number to return.

```yaml
Type: Int32
Parameter Sets: List
Aliases:
Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Select

Comma (",") separated list of properties to select in the result entitlements.

Valid values: 'Projects, 'Extensions', 'Grouprules'

```yaml
Type: String
Parameter Sets: List
Aliases:
Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS