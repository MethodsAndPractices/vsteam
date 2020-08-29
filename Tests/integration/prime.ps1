[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
param(   
   [ValidateSet('TFS2017', 'TFS2018', 'AzD2019', 'VSTS', 'AzD', 'TFS2017U1', 'TFS2017U2', 'TFS2017U3', 'TFS2018U1', 'TFS2018U2', 'TFS2018U3', 'AzD2019U1', 'Azure2018', 'Azure2017')]
   [string] $version = 'VSTS',
   [switch] $runTests,
   [switch] $coverage,
   [switch] $creds
)

$env:API_VERSION = $version
$env:EMAIL = 'dlbm3@hotmail.com'

switch ($version) {
   {$_ -eq 'TFS2017' -or $_ -eq 'TFS2017U1' -or $_ -eq 'TFS2017U2' -or $_ -eq 'TFS2017U3'} { 
      $env:ACCT = 'http://tfs2017:8017/tfs/defaultcollection'
      $env:PAT = 'azviwuingwc4clnmhabtwj6364odxq6mh42pgew63ciufgibuflq'
   }
   {$_ -eq 'TFS2018' -or $_ -eq 'TFS2018U1' -or $_ -eq 'TFS2018U2' -or $_ -eq 'TFS2018U3'} { 
      $env:ACCT = 'http://tfs:8018/tfs/defaultcollection'
      $env:PAT = '7ff2su4ww2ekc2n2zm4ttquytva52e5wk7fgclht36uxbpbix6zq'
   }
   {$_ -eq 'AzD2019' -or $_ -eq 'AzD2019U1'} { 
      $env:ACCT = 'http://tfs2019:8019/defaultcollection'
      $env:PAT = '7bj4hsa6f3bqq4mfl42h5ex4gm4pjgzzpeuojryz4ifzymgiwowa'
   }
   "Azure2017" {
      $env:API_VERSION = 'TFS2017'
      $env:ACCT = 'http://sonarqube.eastus2.cloudapp.azure.com:8080/tfs/vsteam'
      $env:PAT = 'yyzb5jhjtv62cdigowgy66q2zo3oop4i4jejzpuaxmbclxvhnzua'
   }
   "Azure2018" {
      $env:API_VERSION = 'TFS2018'
      $env:ACCT = 'http://winbldbox3.centralus.cloudapp.azure.com:8080/tfs/defaultcollection'
      $env:PAT = 'rpjp7mfgp6krgj5x43helqidxwg4yq6zexrtdw6ovzfycohi76aa'
   }
   Default {
      $env:ACCT = 'tooltester'
      $env:PAT = '3as4pkyrlm2a5gbtctjjzmuatmcy3thrchtrd775kzvutqztnxnq'
   }
}

if ($creds.IsPresent) {
   $pw = ConvertTo-SecureString '2hshbr2nc7tql5tnlgacktamzertz3jq76646w7aybbijsfybwaa' -AsPlainText -Force
   $c = New-Object PSCredential('dbrown@microsoft.com', $pw)
   return $c
}

Write-Output $env:ACCT

if ($runTests.IsPresent) {
   if ($coverage.IsPresent) {
      Invoke-Pester -Output Detailed -CodeCoverage ..\src\*.ps*
   }
   else {
      Invoke-Pester -Output Detailed
   }
}