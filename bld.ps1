. ./Merge-Files.ps1
Merge-Files -inputFile ./Source/Classes/_classes.json
Merge-Files -inputFile ./Source/formats/_formats.json
Merge-Files -inputFile ./Source/Private/_private.json
Merge-Files -inputFile ./Source/Public/_public.json
Merge-Files -inputFile ./Source/types/_types.json

Copy-Item -Path ./Source/VSTeam.psm1 -Destination ./dist/VSTeam.psm1
Copy-Item -Path ./Source/en-US -Destination ./dist/ -Recurse -Force

$newValue = ((Get-ChildItem -Path "./Source/Public" -Filter '*.ps1').BaseName | ForEach-Object -Process { Write-Output "'$_'" }) -join ','
(Get-Content "./Source/VSTeam.psd1") -Replace ("FunctionsToExport.+", "FunctionsToExport = ($newValue)") | Set-Content "./dist/VSTeam.psd1"
