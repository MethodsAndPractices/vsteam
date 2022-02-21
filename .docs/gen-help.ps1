Write-Verbose 'Clearing old files'

$path = $PSScriptRoot

$docsPath = "$path/../docs"

if ((Test-Path $docsPath) -eq $false) {
   New-Item -ItemType Directory -Name $docsPath | Out-Null
}

Get-ChildItem $docsPath | Remove-Item

Write-Verbose 'Merging Markdown files'
if (-not (Get-Module Trackyon.Markdown -ListAvailable)) {
   Install-Module Trackyon.Markdown -Scope CurrentUser -Force
}

merge-markdown $path $docsPath

Write-Verbose 'Creating new file'

if (-not (Get-Module platyPS -ListAvailable)) {
   Install-Module platyPS -Scope CurrentUser -Force
}

$helpFilePath = "$path/../Source/en-US"

[System.IO.FileInfo]$helpOutput = New-ExternalHelp $docsPath -OutputPath $helpFilePath -Force | Out-String

# below fixes broken links from the module help file
# it will link to the docs website directly
[xml]$xmlMaml = Get-Content "$helpFilePath/VSTeam-Help.xml"
$relatedLinks = $xmlMaml.helpItems.command.relatedLinks.navigationLink
$relatedLinks | ForEach-Object {
   $_.uri = "https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/$($_.linkText)"
}
$xmlMaml.Save("$helpFilePath/VSTeam-Help.xml")

Write-Verbose $helpOutput