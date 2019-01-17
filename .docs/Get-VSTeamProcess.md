<!-- #include "./common/header.md" -->

# Get-VSTeamProcess

## SYNOPSIS

<!-- #include "./synopsis/Get-VSTeamProcess.md" -->

## SYNTAX

## DESCRIPTION

The list of Processs Templates returned can be controlled by using the top and skip parameters.

You can also get a single Process Template by name or id.

You must call Add-VSTeamAccount before calling this function.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------

```PowerShell
PS C:\> Get-VSTeamProcess
```

This will return all the Process Templates

### -------------------------- EXAMPLE 2 --------------------------

```PowerShell
PS C:\> Get-VSTeamProcess -top 5 | Format-Wide
```

This will return the top five Process Templates only showing their name

## PARAMETERS

<!-- #include "./params/ProcessName.md" -->

### -Top

Specifies the maximum number to return.

```yaml
Type: Int32
Parameter Sets: List
Default value: 100
```

### -Skip

Defines the number of Processs Templates to skip. The default value is 0

```yaml
Type: Int32
Parameter Sets: List
Default value: 0
```

### -Id

The id of the Process Template to return.

```yaml
Type: String
Parameter Sets: ByID
Aliases: ProcessID
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Add-VSTeamAccount](Add-VSTeamAccount.md)

[Add-VSTeamProject](Add-VSTeamProject.md)