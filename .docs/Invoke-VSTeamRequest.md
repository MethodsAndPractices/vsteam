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

<!-- #include "./params/projectName.md" -->

### -ContentType

Specifies the content type of the request.

If this parameter is omitted and the request method is POST, the content type will be set to application/json.

Otherwise, the content type is not specified in the call.

```yaml
Type: String
Default value: application/json
```

### -Method

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
Default value: Get
```

### -Body

Specifies the body of the request. The body is the content of the request that follows the headers.

You can pipe a body value to Invoke-VSTeamRequest.

The Body parameter can be used to specify a list of query parameters or specify the content of the response.

When the input is a GET request and the body is an IDictionary (typically, a hash table), the body is added to the URI as query parameters. For other GET requests, the body is set as the value of the request body in the standard name=value format.

```yaml
Type: Object
Accept pipeline input: true (ByValue)
```

### -InFile

Path and file name to the file that contains the contents of the request. If the path is omitted, the default is the current location.

```yaml
Type: String
```

### -OutFile

Specifies the output file for which this function saves the response body. Enter a path and file name. If you omit the path, the default is the current location.

```yaml
Type: String
```

### -Area

The area to find the resource. You can tab complete this value. It can be filtered by passing -subDomain first.

```yaml
Type: String
```

### -Resource

The name of the feature you want to manipulate. You can tab complete this value if you pass -Area before this parameter.

```yaml
Type: String
```

### -Id

The unique value of the item you want to work with.

```yaml
Type: String
```

### -Version

The version of the API you wish to target.

```yaml
Type: String
```

### -SubDomain

The SubDomain before .dev.azure.com. For example, to target Release Management you must use the SubDomain vsrm.

```yaml
Type: String
```

### -JSON

Converts the PowerShell object into JSON and displays in the console.

```yaml
Type: Switch
```

### -AdditionalHeaders

Adds additional headers to the request

```yaml
Type: Hashtable
```

<!-- #include "./params/useProjectId.md" -->

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
