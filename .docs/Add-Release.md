#include "./common/header.md"

# Add-Release

## SYNOPSIS
#include "./synopsis/Add-Release.md"

## SYNTAX

### ById (Default)
```
Add-Release [-ProjectName] <String> -Description <String> [-Name <String>] [-SourceBranch <String>]
 -ArtifactAlias <String> -DefinitionId <Int32> -BuildId <String> [-Force]
```

### ByName
```
Add-Release [-ProjectName] <String> -Description <String> [-Name <String>] [-SourceBranch <String>] [-Force]
 [-DefinitionName <String>] [-BuildNumber <String>]
```

## DESCRIPTION
Add-Release will queue a new release.

The environments will deploy according to how the release definition is 
configured in the Triggers tab.

You must call Add-TeamAccount before calling this function.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
PS C:\> Get-Build | ft id,name

id name
-- ----
44 Demo-CI-44


PS C:\> Get-ReleaseDefinition -Expand artifacts | ft id,name,@{l='Alias';e={$_.artifacts[0].alias}}

id name    Alias
-- ----    -----
 1 Demo-CD Demo-CI


PS C:\> Add-Release -DefinitionId 1 -Description Test -ArtifactAlias Demo-CI -BuildId 44
```

This example shows how to find the Build ID, Artifact Alias, and Release Defintion ID required to start a release. 
If you call Set-DefaultProject you can use Example 2 which is much easier.

### -------------------------- EXAMPLE 2 --------------------------
```
PS C:\> Add-Release -DefinitionName Demo-CD -Description Test -BuildNumber Demo-CI-44
```

This command starts a new release using the Demo-CD release defintion and the build with build number Demo-CI-44.

You must set a default project to tab complete DefinitionName and BuildNumber.

## PARAMETERS

### -DefinitionId
The id of the release defintion to use.

```yaml
Type: Int32
Parameter Sets: ById
Aliases: 

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description to use on the release.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ArtifactAlias
The alias of the artifact to use with this release.

```yaml
Type: String
Parameter Sets: ById
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of this release.

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

### -BuildId
The id of the build to use with this release.

```yaml
Type: String
Parameter Sets: ById
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

#include "./params/projectName.md"

### -DefinitionName
The name of the release defintion to use.

```yaml
Type: String
Parameter Sets: ByName
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SourceBranch
The branch of the artifact

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

#include "./params/force.md"

### -BuildNumber
The number of the build to use.

```yaml
Type: String
Parameter Sets: ByName
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

## INPUTS

### System.String

## OUTPUTS

## NOTES
This function has a Dynamic Parameter for ProjectName that specifies the
project for which this function gets release s.

You can tab complete from a list of available projects.

You can use Set-DefaultProject to set a default project so you do not have
to pass the ProjectName with each call.

## RELATED LINKS

