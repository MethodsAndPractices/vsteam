<!-- #include "./common/header.md" -->

# Invoke-VSTeamRequest

## SYNOPSIS

<!-- #include "./synopsis/Invoke-VSTeamRequest.md" -->

## SYNTAX

## DESCRIPTION

Invoke-VSTeamRequest allows you to call a TFS/AzD REST API much easier than using Invoke-WebRequest directly. The shape of the URI and authentication is all handled for you.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Invoke-VSTeamRequest -resource projectHistory -version '4.1-preview' -Verbose
```

This command will return the project history.

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> ivr -area release -resource releases -version '4.1-preview' -subDomain vsrm -Verbose
```

This command will return the releases for a project.

## PARAMETERS

### -AdditionalHeaders

Adds additional headers to the request

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContentType

Specifies the content type of the request.

If this parameter is omitted and the request method is POST, the content type will be set to application/json.

Otherwise, the content type is not specified in the call.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: application/json
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExpandValue
Many operations return an object with a count and a value field, which needs to be expanded, this provides a shortcut to expand the values.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Value

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InFile

Path and file name to the file that contains the contents of the request. If the path is omitted, the default is the current location.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -JSON

Converts the PowerShell object into JSON and displays in the console.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutFile

Specifies the output file for which this function saves the response body. Enter a path and file name. If you omit the path, the default is the current location.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

<!-- #include "./params/projectName.md" -->

### -QueryString
{{ Fill QueryString Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Team
Team to include in the URL

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
Complete URL instead of building up from the parts

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```


<!-- #include "./params/useProjectId.md" -->

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -area

The area to find the resource.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -body

Specifies the body of the request. The body is the content of the request that follows the headers. You can also pipe a body value to Invoke-VSTeamRequest.

The Body parameter can be used to specify a list of query parameters or specify the content of the response.

When the input is a GET request and the body is an IDictionary (typically, a hash table), the body is added to the URI as query parameters. For other GET requests, the body is set as the value of the request body in the standard name=value format.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -id

The unique value of the item you want to work with.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -method

Specifies the method used for the request. The acceptable values for this parameter are:

- Get
- Post
- Patch
- Delete
- Options
- Put
- Default
- Trace
- Head
- Merge

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Get, Post, Patch, Delete, Options, Put, Default, Head, Merge, Trace

Required: False
Position: Named
Default value: Get
Accept pipeline input: False
Accept wildcard characters: False
```

### -resource

The name of the feature you want to manipulate.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -subDomain

The SubDomain before .dev.azure.com. For example, to target Release Management you must use the SubDomain vsrm.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -version

The version of the API you wish to target.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
