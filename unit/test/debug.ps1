Import-Module ..\team.psd1 -Force -Verbose
Add-VSTeamAccount -Account http://10.0.0.5:8080/tfs/DefaultCollection -PersonalAccessToken vuhtbaixci3me7dag364fgp2hccdgzh6zznrvhvfgjzkxrrtmwpa -Verbose
Set-VSTeamDefaultProject nodeDemo -Verbose
Remove-VSTeamRelease -id 1 -Verbose -Force