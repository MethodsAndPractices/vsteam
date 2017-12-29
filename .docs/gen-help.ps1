Write-Output 'Clearing old files'
Get-ChildItem ..\docs | Remove-Item
Write-Output 'Merging Markdown files'
markdown-include $PSScriptRoot $PSScriptRoot\..\docs
Write-Output 'Creating new file'
Import-Module platyPS -Force
New-ExternalHelp ..\docs -OutputPath ..\en-US -Force