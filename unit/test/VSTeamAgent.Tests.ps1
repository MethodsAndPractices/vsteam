Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/VSTeamDirectory.ps1"
. "$here/../../Source/Private/applyTypes.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamJobRequest.ps1"
. "$here/../../Source/Classes/VSTeamJobRequest.ps1"
. "$here/../../Source/Classes/$sut"
#endregion

Describe "VSTeamAgent" {   
   Context "GetChildItem" {
      $resultsAzD = Get-Content "$PSScriptRoot/sampleFiles/jobrequestsAzD.json" -Raw | ConvertFrom-Json
      Mock Get-VSTeamJobRequest { 
         $objs = @()

         foreach ($item in $resultsAzD.value) {
            $objs += [VSTeamJobRequest]::new($item)
         }

         Write-Output $objs
      }
      
      $testAgent = Get-Content "$PSScriptRoot\sampleFiles\agentSingleResult.json" -Raw | ConvertFrom-Json
      $target = [VSTeamAgent]::new($testAgent, 1)

      It "should return child items." {
         $actual = $target.GetChildItem()
         $actual | Should not be $Null
      }
   }
}