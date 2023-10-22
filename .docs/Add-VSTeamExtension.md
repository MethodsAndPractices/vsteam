<!-- #include "./common/header.md" -->

# Add-VSTeamExtension

## SYNOPSIS

<!-- #include "./synopsis/Add-VSTeamExtension.md" -->

## SYNTAX

## DESCRIPTION

<!-- #include "./synopsis/Add-VSTeamExtension.md" -->

## EXAMPLES

### Example 1

```powershell
Add-VSTeamExtension -PublisherId "MyPublisher" -ExtensionId "MyExtension"
```

This command installs the specified extension "MyExtension" from the publisher "MyPublisher" into the account/project collection.

### Example 2

```powershell
Add-VSTeamExtension -PublisherId "AnotherPublisher" -ExtensionId "AnotherExtension" -Version "1.2.3"
```

This command installs version "1.2.3" of the extension "AnotherExtension" from the publisher "AnotherPublisher" into the account/project collection.

### Example 3

```powershell
$myExtensionDetails = @{
    PublisherId = "SamplePublisher";
    ExtensionId = "SampleExtension";
    Version = "2.0.0";
}

Add-VSTeamExtension @myExtensionDetails
```

This example uses a hashtable to specify the details of the extension and installs version "2.0.0" of the extension "SampleExtension" from the publisher "SamplePublisher" into the account/project collection.

### Example 4

```powershell
$extensions = Import-Csv -Path "C:\path\to\extensions.csv"

foreach ($ext in $extensions) {
    Add-VSTeamExtension -PublisherId $ext.PublisherId -ExtensionId $ext.ExtensionId -Version $ext.Version
}
```

This example reads a CSV file containing a list of extensions with their PublisherId, ExtensionId, and Version, and installs each extension into the account/project collection.

### Example 5

```powershell
Add-VSTeamExtension -PublisherId "DevOpsTools" -ExtensionId "CI_CD_Tool"
```

This command installs the specified extension "CI_CD_Tool" from the publisher "DevOpsTools" into the account/project collection. If there are multiple versions available, the latest version will be installed by default.

## PARAMETERS

### PublisherId

The id of the publisher.

```yaml
Type: String
Required: True
```

### ExtensionId

The id of the extension.

```yaml
Type: String
Required: True
```

### Version

The version of the extension. Example: "0.1.35".

```yaml
Type: String
Required: False
```

## INPUTS

## OUTPUTS

## NOTES

<!-- #include "./common/prerequisites.md" -->

## RELATED LINKS



[Add-VSTeamExtension](Add-VSTeamExtension.md)

[Get-VSTeamExtension](Get-VSTeamExtension.md)

[Remove-VSTeamExtension](Remove-VSTeamExtension.md)

[Update-VSTeamExtension](Update-VSTeamExtension.md)
