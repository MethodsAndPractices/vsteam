# These lines were repeated in every test so I moved them here

[CmdletBinding()]
param(
   [Parameter(Mandatory = $true, Position = 0)]
   [string] $testPath,
   [switch] $private,
   [switch] $doNotPrimeCache
)
Import-Module SHiPS

$baseFolder = "$PSScriptRoot/../../.."
$sampleFiles = "$PSScriptRoot/../../SampleFiles"

# Changed to only import this type if the dll is missing and exists in the path, since PS throws an exception when trying to import a dll already in memory
$vsTeamDllPath = "$baseFolder/dist/bin/vsteam-lib.dll"
if (Test-Path -Path $vsTeamDllPath) {
   try {
      Add-Type -Path $vsTeamDllPath -ErrorAction SilentlyContinue
   } catch {
      if ($PSItem.Exception.Message -ne 'Assembly with same name is already loaded') {
         throw $PSItem.Exception.Message
      }
   }
}

$sut = (Split-Path -Leaf $testPath).Replace(".Tests.", ".")

. "$baseFolder/Source/Private/common.ps1"
. "$baseFolder/Source/Private/applyTypes.ps1"

if ($private.IsPresent) {
   . "$baseFolder/Source/Private/$sut"
} else {   
   . "$baseFolder/Source/Public/$sut"
}

if ($doNotPrimeCache.IsPresent) {
   return
}

# Prime the project cache with an empty list. This will make sure
# any project name used will pass validation and Get-VSTeamProject 
# will not need to be called.
[vsteam_lib.ProjectCache]::Update([string[]]@(), 120)

function Open-SampleFile {
   param(
      [Parameter(Mandatory = $true, Position = 0)]
      [string] $file,
      [switch] $ReturnValue,
      # The index of the value array to return
      [int] $index = -1, 
      [switch] $Json
   )
   if ($Json.IsPresent) {
      return $(Get-Content "$sampleFiles\$file" -Raw | ConvertTo-Json)
   }
   
   if ($ReturnValue.IsPresent) {
      return $(Get-Content "$sampleFiles\$file" -Raw | ConvertFrom-Json).value
   } else {
      if ($index -eq -1) {
         return $(Get-Content "$sampleFiles\$file" -Raw | ConvertFrom-Json)
      } else {
         return $(Get-Content "$sampleFiles\$file" -Raw | ConvertFrom-Json).value[$index]
      }
   }
}

function _trackProcess {
   if ($iTracking -gt 9) {
      return [PSCustomObject]@{
         isReady         = $true
         operationStatus = [PSCustomObject]@{ state = 'Ready' }
      }
   }

   return [PSCustomObject]@{
      isReady         = $false
      createdBy       = [PSCustomObject]@{ }
      authorization   = [PSCustomObject]@{ }
      data            = [PSCustomObject]@{ }
      operationStatus = [PSCustomObject]@{ state = 'InProgress' }
   }
}