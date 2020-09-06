Write-Verbose 'Clearing old files'

if ((Test-Path ..\docs) -eq $false) {
   New-Item -ItemType Directory -Name ..\docs
}

Get-ChildItem ..\docs | Remove-Item

Write-Verbose 'Merging Markdown files'
if(-not (Get-Module Trackyon.Markdown -ListAvailable)) {
   Install-Module Trackyon.Markdown -Scope CurrentUser -Force
}

merge-markdown $PSScriptRoot $PSScriptRoot\..\docs

Write-Verbose 'Creating new file'

if(-not (Get-Module platyPS -ListAvailable)) {
   Install-Module platyPS -Scope CurrentUser -Force
}

$helpOutput = New-ExternalHelp ..\docs -OutputPath ..\Source\en-US -Force | Out-String

Write-Verbose $helpOutput