# This file is merging and updating the help files written in markdown.
# First they are merged into a destination folder. Afterwards, the help files are used to
# generate the MAML help files as an external help file.
# MAML file is generated with platyPS and finally related links given in the documentation
# are prepared to point the official documentation page of VSTeam.
[CmdletBinding()]
param (
   [Parameter(Mandatory = $true, Position = 0)]
   [string]
   $DocsInputPath,
   [Parameter(Mandatory = $true)]
   [string]
   $OutputPath,
   [Parameter(Mandatory = $true)]
   [string]
   $HelpFilePath,
   [Parameter(Mandatory =$true)]
   [string]
   $ModulePath
)

. $PSScriptRoot\Test-HelpFileDocumentation.ps1

Write-Verbose 'Clearing old files'

if ((Test-Path $OutputPath) -eq $false) {
   New-Item -ItemType Directory -Name $OutputPath | Out-Null
}

Get-ChildItem $OutputPath | Remove-Item

Write-Verbose 'Merging Markdown files'
if (-not (Get-Module Trackyon.Markdown -ListAvailable)) {
   Install-Module Trackyon.Markdown -Scope CurrentUser -Force
}

Merge-Markdown $DocsInputPath $OutputPath


Test-HelpFileDocumentation -MarkdownOutputPath $OutputPath -ModulePath $ModulePath

Write-Verbose 'Creating new file'

if (-not (Get-Module platyPS -ListAvailable)) {
   Install-Module platyPS -Scope CurrentUser -Force
}

[System.IO.FileInfo]$helpOutput = New-ExternalHelp $OutputPath -OutputPath $HelpFilePath -ShowProgress -Force

# below fixes broken links from the module help file
# it will link to the docs website directly
[xml]$xmlMaml = Get-Content $helpOutput.FullName
$relatedLinks = $xmlMaml.helpItems.command.relatedLinks.navigationLink
$relatedLinks | ForEach-Object {
   $_.uri = "https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/$($_.linkText)"
}
$xmlMaml.Save($helpOutput.FullName)

Write-Verbose ($helpOutput | Out-String)