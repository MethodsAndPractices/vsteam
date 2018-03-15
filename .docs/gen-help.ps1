Write-Output 'Clearing old files'

if ((Test-Path ..\docs) -eq $false) {
   New-Item -ItemType Directory -Name ..\docs
}


Get-ChildItem ..\docs | Remove-Item
Write-Output 'Merging Markdown files'
markdown-include $PSScriptRoot $PSScriptRoot\..\docs
Write-Output 'Creating new file'
Import-Module platyPS -Force
New-ExternalHelp ..\docs -OutputPath ..\en-US -Force