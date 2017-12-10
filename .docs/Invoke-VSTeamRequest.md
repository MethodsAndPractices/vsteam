#include "./common/header.md"

# Invoke-VSTeamRequest

## SYNOPSIS
#include "./synopsis/Invoke-VSTeamRequest.md"

## SYNTAX

```
Invoke-VSTeamRequest [-Resource] <String> [-Area] <String> [-Version] <String> [-SubDomain <String>] [-Method {Get | Post | Put | Delete | Options | Patch}] [-Id <String>] [-Body <Object>] [-InFile <String>] [-OutFile <String>] [-ProjectName] <String>
```

## DESCRIPTION
Invoke-VSTeamRequest allows you to call a TFS/VSTS REST API much easier than using Invoke-WebRequest directly. The shape of the URI and authentication is all handled for you.

## EXAMPLES
### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Invoke-VSTeamRequest -resource projecthistory -version '4.1-preview' -Verbose
```

This command will return the project history.

### -------------------------- EXAMPLE 2 --------------------------
PS C:\> ivr -area release -resource releases -version '4.1-preview' -subDomain vsrm -Verbose

This command will return the releases for a project.

## PARAMETERS

#include "./params/projectName.md"

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
Default value: Get
Accept pipeline input: False
Accept wildcard characters: False
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
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: Get
Accept pipeline input: False
Accept wildcard characters: False
```

### -Body
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

### -InFile
Gets the content of the request from a file.

Enter a path and file name. If you omit the path, the default is the current location.

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

### -Area
The area to find the resource

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

### -Resource
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

### -Id
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

### -Version
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

### -SubDomain
The SubDomain between your account and visualstudio.com. For example, to target Release Management you must use the SubDomain vsrm.

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
Type: Switch
Parameter Sets: (All)
Aliases: 

Required: False
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